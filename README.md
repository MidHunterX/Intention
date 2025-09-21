# Intention

Inter-Operating System Workflow Automation based on relaying user intent in a multi-boot setup.

## XOSCRP: Cross-OS Context Relay Protocol

It uses a bespoke Cross Operating System Context Relay Protocol for
communicating user intent for workspace context changes between different
operating systems in a multi-boot setup.

### Prerequisites

- A dual-boot system with Linux and Windows.
- A shared NTFS partition accessible from both operating systems.
- NTFS support on Linux (`ntfs-3g` package is common).

### ⚠️ Important Warning: Windows Hibernation / Fast Startup

When Windows uses **hibernation** or **Fast Startup**, the NTFS partition is left in an **unsafe state**.
If Linux writes to the partition in this condition, it can cause **serious data corruption**.

**Mitigation:**

- Disable Fast Startup in Windows (`Control Panel → Power Options`).
- Disable hibernation completely:

  ```powershell
  powercfg /h off
  ```

- Always perform a **full shutdown** before switching to Linux.
