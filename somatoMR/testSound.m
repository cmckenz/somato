a1 = mglInstallSound(a.cond1)
a2 = mglInstallSound(a.cond2)
a3 = mglInstallSound(a.cond3)
a4 = mglInstallSound(a.cond4)

mglSetSound(a1, 'deviceID',5)
mglSetSound(a2, 'deviceID',5)
mglSetSound(a3, 'deviceID',5)
mglSetSound(a4, 'deviceID',5)

mglPlaySound(a1)
mglPlaySound(a2)
mglPlaySound(a3)
mglPlaySound(a4)