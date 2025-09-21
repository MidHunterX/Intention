# Intention

Inter Operating System Workflow Automation by relaying user intent in a multi-boot setup.

Imagine doing Development works in Linux and you want to switch to Windows for extensive Graphic Design work in InDesign or you might want to Play some games along with a custom AutoHotKey Script. Since Windows is super slow and clunky, you'll have to wait for that thing to be responsive, navigate the slow UI, open up workspaces, open up apps, wait for everything to load, too much cognitive resistance sacrificing your flow state.

With this new setup, you just state your intent, sit back and relax thinking about the next task you want to do. Meanwhile this automation will do all the workspace setup for you.

## Usage

```bash
# Lists all available procedures exposed by other Operating Systems
intention list

# Set your intention for using another OS in near future
intention set "function_name"

# Unset your intention
intention unset "function_name"

# Reboot to the appropriate OS and set up the workspace for your intention
intention reboot "function_name"
```

## XOSCRP: Cross-OS Context Relay Protocol

It uses a bespoke Cross Operating System Context Relay Protocol for communicating user intent for workspace context changes between different operating systems in a multi-boot setup.

- Sees each Operating System as a "server" with multiple capabilities.
- Uses FileSystem for communication and directory as message queue.

### Prerequisites

- A dual-boot system with Linux and Windows.
- GRUB Boot Manager configured to boot to Linux.
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
