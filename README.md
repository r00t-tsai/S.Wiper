# S.Wiper

**Automated Disk Sanitizer**

A windows utility designed for the total sanitization of storage disks and media. This tool is designed for complete OS data wipe/disk format regardless of firmware type.

---

## Architecture Overview

> **⚠️ NOTICE:** The device to be formatted should have **Secure Boot** disabled.

| Component | File | Language | Primary Function |
| :--- | :--- | :--- | :--- |
| **Automation** | `_wiper.py` | Python | Privilege escalation, boot-mode detection, and wiper deployment. |
| **UEFI** | `BOOTX64.c` | C (EDK II) | Pre-boot wiper that wipes all detected Block I/O devices. |
| **Legacy** | `bootloader.asm` | x86 Assembly | 16-bit MBR-resident wiper for BIOS-based systems. |

---

## Implementation

### Automation (`_wiper.py`)
The automated installer will:
* **Privilege Escalation**: Uses `ShellExecuteW` with the `runas` verb to ask the user to run it as Administrator.
* **Environment Analysis**: Detects whether the system uses **UEFI** or **Legacy BIOS** by parsing `diskpart` volume lists and checking the `firmware_type` environment variable.
* **UEFI Detection**: 
    * Mounts the hidden EFI System Partition (ESP) using `diskpart`.
    * Uses `bcdedit` to create a new boot entry and forces the Windows Boot Manager (`{bootmgr}`) to point to the C `.efi` binary.
    * Sets boot timeouts to `0` to ensure the sanitization executes immediately upon restart.
* **Legacy Detection**: Uses `bootsect.exe /nt60` to update the Volume Boot Record and copies the assembly wiper to the system drive.

### Compilation
* **UEFI** - Use a pre-built compiler, mainly [MinGW64](https://sourceforge.net/projects/mingw-w64/) with [GNU Compiler](https://gcc.gnu.org/install/download.html).
* **LEGACY** - Use [Nasm](https://www.nasm.us/) to compile the assembly payload.

---

> **⚠️ CRITICAL NOTICE:** This is a functional destructive utility. Running the installer completely will result in **permanent data loss** and render the host operating system **unbootable**, so make sure you execute this code on a device that you own.

---

## Legal Disclaimer
The author of this project is not responsible for any damages or illegal activities performed with this code. It is provided "as-is" for the purpose of disk formatting/sanitization.

---

## License
This utility is licensed under [MIT.](https://github.com/r00t-tsai/S.Wiper/blob/main/LICENSE)