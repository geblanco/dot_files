import sys
import zmq
import threading

from time import sleep
from filelock import FileLock, Timeout


class Singleton(object):
    def __init__(
        self, lock_path, port=5678,
        handler=None, wakeup_msg="<WAKE_UP>"
    ):
        self._lock_path = lock_path
        self._lock = FileLock(lock_path, timeout=0.1)
        self._port = port
        self._handler = handler
        self._wakeup_msg = wakeup_msg
        self._recv_thread = None
        self._context = zmq.Context()

    def _signal_close(self):
        self.wakeup_call("<END>")

    def add_handler(self, handler):
        self._handler = handler

    def instance_running(self):
        running = False
        try:
            self._lock.acquire()
        except Timeout:
            running = True
        finally:
            return running

    def wakeup_call(self, msg=None):
        send_socket = self._context.socket(zmq.PUSH)
        send_socket.connect(f"tcp://127.0.0.1:{self._port}")
        send_socket.send_string(msg if msg else self._wakeup_msg)

    def recv_handler(self):
        # print("Received handler started")
        # print("Received handler acquired")
        self._recv_socket = self._context.socket(zmq.PULL)
        self._recv_socket.bind(f"tcp://127.0.0.1:{self._port}")
        while not self._recv_socket.closed:
            try:
                #check for a message, this will not block
                msg = self._recv_socket.recv_string(flags=zmq.NOBLOCK)
                # print(msg)
                if self._handler is not None:
                    self._handler(msg)
            except zmq.Again as e:
                pass
            sleep(0.2)
        self._lock.release()
        # print("Received handler end")

    def start(self):
        started = False
        if not self.instance_running():
            self._recv_thread = threading.Thread(target=self.recv_handler)
            self._recv_thread.start()
            started = True
        return started

    def stop(self, wakeup_singleton=True, close_app=False):
        if self._recv_thread is not None:
            self._recv_socket.close()
            self._recv_thread.join()
        elif wakeup_singleton:
            self.wakeup_call()
        if close_app:
            sys.exit(0)

""" Example

from singleton import Singleton
single_instance = Singleton(lock_path="/tmp/singleton.lock")

def do_when_others_start():
    # important stuff, make your application visible...
    pass

single_instance.add_handler(do_when_others_start)

if not single_instance.start():
    # instance already running, close
    # 
    single_instance.close(wakeup_singleton=True, close_app=True)

"""
