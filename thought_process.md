## Day 1

I'm thinking of creating a communication protocol between the two dual-boot operating systems for making my workspace automation tool.
Currently Linux (needs ntfs-3g / ntfsprogs) and Windows.
Communicates using JSON messages (inspired from RPC) which get queued on a shared storage memory (on NTFS inspired from Message Queues).
No sharing commands to be executed for security purposes.

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
