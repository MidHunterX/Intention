![Intention Banner Image](./.assets/intention_banner.jpg)

# Intention

Inter Operating System Workflow Automation by relaying user intent in a multi-boot setup.

Imagine doing Development works in Linux and you want to switch to Windows for extensive Graphic Design work in InDesign or you might want to Play some games along with a custom AutoHotKey Script. Since Windows is super slow and clunky, you'll have to wait for that thing to be responsive, navigate the slow UI, open up workspaces, open up apps, wait for everything to load, too much cognitive resistance sacrificing your flow state.

With this new setup, you just state your intent, sit back and relax thinking about the next task you want to do. Meanwhile this automation will do all the workspace setup for you.

> [!NOTE]
> The best solution to this problem is to have KVM + QEMU + GPU Pass-Through
> setup. This solution is meant to be used in a multi-boot setup as a
> workaround for devices without a dedicated GPU and MUX.

### What it does

- Gets available procedures exposed by other Operating System.
- Communicates your intent to the other Operating System.
- Reboot and automatically select the OS entry on the GRUB Boot Manager.
- Automatically sets up wallpaper, opens apps, change settings, etc. for you.

### Prerequisites

- A dual-boot system with Linux and Windows.
- GRUB Boot Manager configured to boot to Linux.
- A shared NTFS partition accessible from both operating systems.
- NTFS support on Linux (`ntfs-3g` package is common).

## 🫴 Usage

### Linux (Procedure Call)

```bash
# Lists all available procedures exposed by other Operating Systems
intention --list

# Immediately move to the appropriate OS and set up workspace
intention "function_name"
```

### Windows (Procedure Server)

Run the `recv.ps1` once to install the server as a Windows task entry.

```
.xoscrp
├── message_queue
├── procedures
│   ├── default.ps1
│   ├── gaming_mode.ps1
│   ├── movie_mode.sh
│   ├── project_expression.sh
│   ├── ...
│   └── {function_files}
└──  recv.ps1
```

## 🧰 How It Works

It uses a bespoke Cross Operating System Context Relay Protocol (XOSCRP); a deferred RPC system over a filesystem for communicating user intent for workspace context changes between different operating systems in a multi-boot setup.

- Each Operating System is seen as a server with multiple capabilities.
- These capabilities can be called by other Operating Systems in an RPC like manner.
- Uses shared File System (NTFS) for fully offline deferred communication of this intent call.
- A directory in this File System is used as a simple message queue.
- After the intent request is made, when the requested OS boots up, it will acknowledge the intent message and act accordingly.

> [!WARNING]
>
> ### Possibility of Data Corruption
>
> When Windows uses **hibernation** or **Fast Startup**, the NTFS partition is left in an **unsafe state**.
> If Linux writes to the partition in this condition, it might cause **serious data corruption**.
> It's due to the way New Technology File System (NTFS) in Windows is designed.
>
> Mitigation:
>
> - Disable Fast Startup in Windows (`Control Panel → Power Options`).
> - Disable hibernation completely:
>   ```powershell
>   powercfg /h off
>   ```
> - Always perform a **full shutdown** before switching to Linux.
