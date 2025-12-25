# Cross Operating System Context Relay Protocol (XOSCRP)

I'm thinking of creating a communication protocol between the two dual-boot operating systems for making my workspace automation tool.
Currently Linux (needs ntfs3 / ntfs-3g / ntfsprogs) and Windows.
Every operating system would have a different set of functions (inspired from RPC) and communicates using JSON messages inside files (UNIX Philosophy) which get queued on a shared storage memory (on NTFS inspired from Message Queues).
No sharing commands to be executed for security purposes. No sophisticated daemons or anything complex just a simple check at startup (KISS principle).

Minimal structure:

```json
{
  "function": "game_mode",
  "os": "windows"
}
```

Full structure:

```json
{
  "function": "game_mode",
  "os": "windows",
  "description": "Run Gaming related workspace setup on startup",
  "params": {
    "profile": "high_perf",
    "steam_app_ids": [570, 730],
    "wallpaper": "D:\wallpapers\lara_croft.jpg"
  }
}
```

Can be extended by developers for more feature handling. This JSON would be stored in an NTFS file system location and executed. No need for IDs as one command needs to be executed only once after startup. After completion, the JSON file would simply be deleted for avoiding trigger on next restart.

This makes it so that each operating system can have different functions based on its capabilities and can be executed from another OS for context switching. Need video editing workspace with all tools opened up in another OS? Call the function, boot into the other OS and done.

I have already developed a script which tells GRUB what OS it should load to next and restarts. Sit back and relax not even sweating about selecting an OS. This project would be a great addition to that.

Basically every OS can be seen as a "server" with different pre-defined functions communicating via file-system "network" and the "protocol" is:

- SEND: Create JSON file with Reciever OS "os" and procedure "function"
- RECV:
  - Get all files in queue; FIFO based on file_created
  - Execute ones with correct "os"
- ACK: Delete the JSON file

## Building an MVP

- Linux (send): Sends a plain file with the name of function as its filename.
- Windows (recv): Get all files in a queue, execute the ones with the correct name and acknowledges by deleting all encountered files.

Bunch of scripts are stored in procedures directory for execution

```
.xoscrp
├──  protocol
│   ├──  procedures
│   │   ├──  default.ps1
│   │   └──  gaming_mode.ps1
│   └──  recv.ps1
└── {function_files}
```

## Building the Final Product

Currently Linux -> Windows unidirectional communication is supported.

### UserFlow

#### Bootstrapping

- GUI to select shared drive/directory
- Save location to Linux cache (Windows registry for bidirectional support)

#### Intent Definition

- Set up intents in JSON on each OS
- Ability to extend intents with post-exec hook for adding shell scripts

#### Execution

State your intention for later time with:

```bash
intention set "function_name"
```

Remove it with:

```bash
intention unset "function_name"
```

Change to the context immediately with:

```bash
intention reboot "function_name"
```

This will immediately reboot to your intended state using `grub-reboot`. Sit back and relax while everything is being taken care of.

## Further polishes

- Making intention work with project-runner and expression.
  So that I can do this for running any projects even without navigating or initializing anything. Just do this on any OS:

```bash
# Working on freelance project (uses project-runner)
intention run project_maid

# Watch a movie with comfortable brightness (on linux)
intention run movie_mode

# Moves to windows, set up workspace and tools for gaming (on windows)
intention run gaming_mode

# Moves to linux, open terminal and set up project (on linux)
intention run project_expression

# Clears all intentions and returns to default state
intention reset
```

- Handle OS default initial state through intention instead of Hyprland in Linux
- Adaptive logic to modify current workspace to match intended state instead of fully exiting and loading from fresh.
- Reboots and talks to GRUB only if there is a change in OS.

```json
{
  "name": "movie_mode",
  "os": "linux",
  "description": "Arrange everything for a nice movie session",
  "params": {
    "start_processes": [],
    "stop_processes": ["sway_idle", "auto_brightness"],
    "script_hook": "movie_mode.sh"
  }
}
```

project-runner (project) would handle dependency installation, initialization, output on browser and tmux

```json
{
  "name": "project_expression",
  "os": "linux",
  "description": "Personal wallpaper engine project",
  "params": {
    "project": "~/Mid_Hunter/work_files/expression/"
  }
}
```

Uses inbuilt logic (wallpaper, executables) for setting up gaming workspace on windows

```json
{
  "name": "gaming_mode",
  "os": "windows",
  "description": "Arrange everything for a nice gaming session",
  "params": {
    "wallpaper": "D:/wallpapers/lara_croft.jpg",
    "executables": ["X:\Mid_Hunter\Playnite\Playnite.DesktopApp.exe"]
  }
}
```

Notes:

- Probably might pivot to keyboard friendly GUI later for better XOSCRP management.
- (OPTIONAL) Might have to look into inner workings of sysvinit, runit and how they handle process management.

### Full RPC Structure

```json
{
  "name": "intent_name",
  "os": "windows|linux",
  "description": "Description of the intent",
  "params": {
    "project": "run_integration/linux_project_path",
    "wallpaper": "windows_wallpaper_path",
    "executables": ["cross_executable"],
    "start_processes": ["linux_systemd_service"],
    "stop_processes": ["linux_systemd_service"],
    "script_hook": "cross_script.sh|ps1"
  }
}
```

### Software Architecture

```python
class Intention:
  def __init__(
    self,
    os: str,
    rpc: Dict,
  ):
    self.os = os
    self.rpc = rpc

  # Project Runner integration
  def run_project(rpc: self.rpc):
    project_path = self.rpc["params"]["project"]
    if self.os == "linux":
      run_project_linux(project_path)
    elif self.os == "windows":
      raise NotImplementedError
    else:
      raise NotImplementedError

  # Expression integration
  def set_wallpaper(rpc: self.rpc):
    wallpaper_path = self.rpc["params"]["wallpaper"]
    if self.os == "linux":
      set_expression_linux(wallpaper_path)
    elif self.os == "windows":
      set_expression_windows(wallpaper_path)
    else:
      raise NotImplementedError

  # Other features ...
```

## Schema Normalization

Instead of using thousands of optional parameters, I'm going to separate them into types so each can be handled separately.

```json
{
  "name": "windows_intent_name",
  "os": "windows",
  "description"?: "Description of the intent",
  "executables"?: [ "exec_path_1", "exec_path_2" ],
  "wallpaper"?: "windows_wallpaper_path",
  "script_hook"?: "cross_script.ps1"
}
```

```json
{
  "name": "linux_intent_name",
  "os": "linux",
  "description"?: "Description of the intent",
  "project"?: "run_integration/linux_project_path",
  "services"?: [ "service_name_1", "service_name_2" ],
  "script_hook"?: "cross_script.sh"
}
```
