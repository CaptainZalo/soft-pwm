#!/usr/bin/python
#
# soft-pwm.sh
#*****************************************************************
#  author:      Mark H. Harris        
#  modified by: Tarjei S. Tjønn
#  license:     GPLv3
#
#   THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND
#   CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES,
#   INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF
#   MECHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#   DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR
#   CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL,
#   SPECIAL, EXEMPLARY, OR CONSEQUENCIAL DAMAGES (INCLUDING, BUT
#   NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#   LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERUPTION)
#   HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN
#   CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR
#   OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE
#   EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#*****************************************************************
## Import the necessary header modules
from time import sleep
import signal as SIGNAL
import RPi.GPIO as GPIO
GPIO.setmode(GPIO.BCM)

## SOFTWARE PWM GPIO23 pin(16)
soft_pwm = 23
GPIO.setup(soft_pwm, GPIO.OUT)

ms_on = .016
ms_off = .004
hup_flag = False

## FUNCTION DEFINITIONS

def motor_duty_on(m_pin, t_delay):
    GPIO.output(m_pin, True)
    sleep(t_delay)
    
def motor_duty_off(m_pin, t_delay):
    GPIO.output(m_pin, False)
    sleep(t_delay)

def end():
    GPIO.cleanup()
    quit()

def ssighup(signum, frame):
    global hup_flag
    global ms_on
    global ms_off
    if (hup_flag):
        ms_on = .016
        hup_flag=False
    else:
        ms_on = .250
        hup_flag=True
    print(" ")
    print("HUP: duty_cycle toggled value: "+str(ms_on))

SIGNAL.signal(SIGNAL.SIGHUP, ssighup)

kb_interrupt = False

while(not kb_interrupt):
    try:
        motor_duty_on(soft_pwm, ms_on)
        motor_duty_off(soft_pwm, ms_off)
    except KeyboardInterrupt:
        kb_interrupt = True
        print(" ")
        print("motor controller ended by interrupt, bye!")

end()
