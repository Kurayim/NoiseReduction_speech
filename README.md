# Introduction

A while ago, I called my brother to discuss a certain matter. He works in a sawmill, and usually, during our phone conversations, I could hardly hear his voice clearly due to the background noise. However, during our last call, the situation was completely different — his voice was very clear and free of any annoying or harsh sounds, to the point where I thought he was outside the workshop. When I asked him where he was, he replied that he was still inside the workshop.

This was very interesting and thought-provoking for me, as it was the first time I could hear his voice without the usual disturbances. The reason for this improvement was that he had recently purchased a new mobile phone. This experience made me wonder how a phone can transmit the main voice signal with high quality while simultaneously suppressing the surrounding noise.

In this project, I decided to simulate a simplified version of this process. To do so, I will record a short audio clip of my own voice in the presence of a constant noise source (such as a fan). The goal is to use filters and signal processing techniques to reduce the environmental noise as much as possible and extract a clearer, more intelligible signal.

In this project, we plan to implement filters such as a low-pass filter, notch filter, adaptive filter (LMS), spectral subtraction, and Wiener filter using MATLAB. After applying each filter to the audio signal, we will analyze the results to evaluate the impact of each method and determine whether there has been an improvement in sound quality. Finally, we will try to combine the methods that produced the best results and assess whether the final output approaches our desired quality level.

Obviously, no filter can completely eliminate noise, but this challenge itself provides motivation to continue the project. If I have enough time, I am also interested in extending this work by applying machine learning models and exploring AI-based approaches to further improve the signal quality.

<p align="center">
  <img src="https://github.com/user-attachments/assets/d888b14b-c9d4-4dc3-9f25-48a39429047e" width="500"/>
</p>


# Orginal Signal
At the beginning of the project, I recorded an audio file of my voice in front of a fan. The purpose of this step is to observe and analyze the time-domain waveform of the original signal as well as its frequency content using a spectrogram.








