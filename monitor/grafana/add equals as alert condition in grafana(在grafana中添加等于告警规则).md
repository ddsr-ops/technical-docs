https://github.com/grafana/grafana/issues/19193

I expect the monitored value to trigger an alarm at 0. So I set the alarm condition of "is within range 0 to 0", 
but he did not trigger the alarm. So I looked at the code and found that'within range'does not include both sides of the boundary. 
So if I think it's equal to zero, call the police. How should I set it?


within range and outside range are not inclusive
So right now you would have to do within range -0.01 to 0.01 or something.