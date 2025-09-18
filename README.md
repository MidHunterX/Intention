# Cross Operating System Context Relay Protocol (XOSCRP)

## Dependencies (Linux)

- `ntfs-3g`: for NTFS mounting support


### ⚠️ Important Warning: Windows Hibernation / Fast Startup

When Windows uses **hibernation** or **Fast Startup**, the NTFS partition is left in an **unsafe state**.
If Linux writes to the partition in this condition, it can cause **serious data corruption**.

**Mitigation:**

* Disable Fast Startup in Windows (`Control Panel → Power Options`).
* Disable hibernation completely:

  ```powershell
  powercfg /h off
  ```
* Always perform a **full shutdown** before switching to Linux.
* If the partition is detected as dirty, do not process the queue until Windows has fully shut down.
