# 🧠 SSVEP EEG Analysis with Frequency and Amplitude Modulated Stimuli

## 🎓 Undergraduate Project Summary

This project analyzes the brain’s response to **Steady-State Visual Evoked Potentials (SSVEPs)** using visual stimuli that are **frequency-modulated (FM)** and **amplitude-modulated (AM)**. EEG signals are recorded from occipital and parietal brain regions and processed to evaluate spectral peaks and signal-to-noise ratios (SNRs) at target stimulus frequencies.

---

## 📂 Project Structure

| File | Description |
|------|-------------|
| `generate_ssvep_stimuli.m` | Generates AM and FM modulated SSVEP signals and sends them to a National Instruments DAQ for presentation. |
| `analyze_ssvep_fm75hz.m` | Processes EEG data for session 1 using FM with a 75 Hz carrier. Calculates FFT and SNR at 15 Hz and 30 Hz. |
| `analyze_ssvep_session2.m` | EEG analysis for session 2, focused on mixed modulation stimuli. |
| `analyze_ssvep_session3.m` | EEG analysis for session 3, includes higher target frequencies like 23 Hz and 46 Hz. |
| `compile_ssvep_response_summary.m` | Compiles peak values from all sessions and fits 2D polynomial regression surfaces to relate stimulus parameters with EEG response strength. |

---

## 🎯 Objectives

- Design visually modulated stimuli using FM and AM techniques.
- Present these signals via DAQ to a subject.
- Record EEG responses from occipital and parietal regions.
- Compute the spectral response using FFT.
- Calculate SNR values to assess signal strength.
- Use regression models to quantify how modulation parameters affect EEG response.

---

## 🧪 Methods

### ✅ Stimulus Generation (`generate_ssvep_stimuli.m`)
- **FM signals**: Created using a sinusoidal carrier modulated in phase by another sine wave.
- **AM signals**: Created as weighted sums of two sinusoids (e.g., 15 Hz and 30 Hz).
- Sent to the DAQ device via `queueOutputData`.

### ✅ EEG Analysis (`analyze_ssvep_*.m`)
- 8-second EEG epochs are extracted after each stimulus event.
- Fast Fourier Transform (FFT) is applied to:
  - Occipital signal
  - Parietal signal
  - Sum (Parietal + Occipital)
  - Difference (Parietal - Occipital)
- **Peak amplitude** is extracted at the target frequencies (15 Hz, 30 Hz, etc.).
