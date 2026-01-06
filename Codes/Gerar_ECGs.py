# import electrocardiogram
import matplotlib.pyplot as plt
from scipy.misc import electrocardiogram
from scipy.io import savemat
import numpy as np
import neurokit2 as nk  # Load the package
import wfdb

"""
# define electrocardiogram as ecg model
ecg = electrocardiogram()

# frequency is 360
frequency = 360

# calculating time data with ecg size along with frequency
time_data = np.arange(ecg.size) / frequency

# plotting tine and ecg model
plt.plot(ecg)
#plt.xlabel("time in seconds")
plt.xlabel("Amostras")
plt.ylabel("Amplitude (mV)")
plt.xlim(0, 1024)
plt.ylim(-2, 2)
# display
plt.show()
print(ecg)
"""
simulated_ecg = nk.ecg_simulate(duration=150, sampling_rate=100, heart_rate=170)
simulated_ecg = 150*simulated_ecg
# nk.signal_plot(simulated_ecg, sampling_rate=360)  # Visualize the signal
# plt.show()
plt.plot(simulated_ecg)
plt.xlim(0, 1024)
titulo = "ECG Artificial 100 Hz"
plt.title(titulo)
plt.show()

# salvar em npy
np.save("ECG_100Hz.npy", simulated_ecg)
# careegar arquivo salvo
data = np.load("ECG_100Hz.npy")
# salva o arquivo em formato mat
savemat("ECG_100Hz.mat", {"data": data})