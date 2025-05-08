# 📸 Deep-Live-Cam Installation Guide (EndeavourOS / Arch Linux)

Dokumentasi ini akan memandu kamu dari awal hingga menjalankan aplikasi **Deep-Live-Cam** dengan dukungan CUDA (GPU NVIDIA).

---

## 🧩 Prasyarat

Install dependensi berikut:

```bash
sudo pacman -S base-devel git ffmpeg python-pyenv tk
```

Tambahkan ke shell config (`~/.zshrc` atau `~/.bashrc`):

```bash
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init --path)"
eval "$(pyenv virtualenv-init -)"
```

Lalu **restart shell** atau `source ~/.zshrc`.

---

## 🐍 Instalasi Python 3.10 via pyenv

```bash
pyenv install 3.10.17
pyenv virtualenv 3.10.17 deepfake
pyenv activate deepfake
```

---

## 📦 Kloning Repository

```bash
git clone https://github.com/hacksider/Deep-Live-Cam.git
cd Deep-Live-Cam
```

---

## 📁 Download Model Files

Unduh dan letakkan model berikut di folder `models/` lihat instruksi di dalam folder models untuk link filenya:

1. **GFPGANv1.4**
2. **inswapper\_128\_fp16.onnx**

---

## 🧪 Setup Virtual Environment (Opsional jika pakai pyenv)

> Sudah dilakukan sebelumnya dengan `pyenv virtualenv`, jadi bisa lanjut install requirements:

```bash
pip install -r requirements.txt
```

---

## ⚡ Install CUDA untuk GPU Acceleration (Opsional tapi direkomendasikan)

Jika kamu punya GPU NVIDIA:

1. Pastikan CUDA Toolkit 11.8 terpasang.
2. Ganti runtime ONNX:

```bash
pip uninstall onnxruntime onnxruntime-gpu
pip install onnxruntime-gpu==1.16.3
```

---

## ✅ Jalankan Aplikasi

Untuk mode CPU:

```bash
python run.py
```

Untuk mode GPU (CUDA):

```bash
python run.py --execution-provider cuda
```

---

## 🐞 Catatan Error Umum

### ❌ `ImportError: cannot enable executable stack`

Jika muncul error terkait `onnxruntime_pybind11_state.so`:

```bash
execstack -c ~/.pyenv/versions/deepfake/lib/python3.10/site-packages/onnxruntime/capi/*.so
```

Instal dulu `execstack` jika belum:

```bash
sudo pacman -S pax-utils
```

### ❌ `AssertionError: model_file ... should exist`

Pastikan file `inswapper_128_fp16.onnx` sudah diletakkan di folder `models/`.

---

## ✅ Mode Penggunaan

### 🎥 Image / Video

1. Jalankan `python run.py`
2. Pilih **source face image** dan **target image/video**
3. Klik `Start`

Hasil akan tersimpan di folder berdasarkan nama video target.

### 📷 Webcam (Live)

1. Jalankan `python run.py` atau `python run.py --execution-provider cuda`
2. Pilih **source face image**
3. Klik `Live`
4. Tunggu preview muncul (10-30 detik)
5. Gunakan OBS untuk streaming layar

---

## 🔚 Menutup Virtualenv

Jika ingin keluar dari virtual environment:

```bash
deactivate
```
