from flask import Flask, jsonify, render_template
import threading
import time
import random

try:
    import serial
    from serial.serialutil import SerialException
except ImportError:
    serial = None

app = Flask(__name__)
temperature = 0
use_fake = False

def read_serial():
    global temperature, use_fake
    try:
        ser = serial.Serial('COM4', 115200, timeout=1)
        print("🔌 Connected to serial port.")
        while True:
            line = ser.readline().decode().strip()
            if line.isdigit():
                temperature = int(line)
            time.sleep(1)
    except (SerialException, AttributeError, OSError) as e:
        print(f"Serial error or not found: {e}")
        use_fake = True
        simulate_data()

def simulate_data():
    global temperature
    print("Using simulated data.")
    while True:
        temperature = random.randint(30, 39)
        time.sleep(4)

@app.route('/')
def index():
    return render_template('index.html')

@app.route('/temp')
def temp():
    return jsonify({'temperature': temperature})

if __name__ == '__main__':
    thread = threading.Thread(target=read_serial, daemon=True)
    thread.start()
    app.run(debug=True)
