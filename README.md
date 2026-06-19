# 🧪 AD-Extreme-Lab: Advanced Active Directory & Evasion Playground

AD-Extreme-Lab is an ultra-lightweight, automated Grey-Box lab designed to test your offensive security skills against real-world enterprise misconfigurations, host-based firewalls, and active Windows Defender (AMSI) evasion scenarios.

The core teaching concept of this lab is **Privilege Escalation (Zero to Hero)**. You start with absolutely zero active directory privileges inside a compromised Linux container, and by systematically exploiting chained misconfigurations, you progressively pivot until you extract Domain Admin credentials.

## 🚀 RAM & Network Topology Optimization
The entire 3-node lab runs flawlessly by leveraging lightweight Windows Server Core images and a CLI-only Kali footprint.

| Node Name | Operating System | IP Address | Assigned RAM | Role / Objective |
| :--- | :--- | :--- | :--- | :--- |
| **DC01** | Windows Server 2022 Core | `192.168.56.10` | 2.0 GB | Primary Domain Controller (`mekke.local`) |
| **DC02** | Windows Server 2022 Core | `192.168.56.11` | 2.0 GB | ADCS / IIS Enrollment Server (Hardened) |
| **Kali** | Kali Linux (CLI Only) | `192.168.56.20` | 1.0 GB | Attacker Workstation / Docker Host |

---

## 🧰 Recommended Attack Tools
All required tools are **automatically pre-installed** during the provision phase inside the Kali box. You will utilize:
* **Network & Discovery:** `nmap`
* **AD Enumeration & Auth:** `crackmapexec` (aliased automatically to `cme` to ensure compatibility across syntax preferences), `impacket-scripts`
* **ACL Modification:** `bloodyAD`
* **ADCS Assessment & Forgery:** `certipy-ad`

---

## 🏁 Captured Flags
Can you collect all three flags to fully compromise the domain?

| Flag | Name | Location | Difficulty | Phase |
| :--- | :--- | :--- | :--- | :--- |
| **Flag 1** | Docker Escape | Linux Host (`192.168.56.20`): `/root/flag_1.txt` | **Medium** | Container breakout via host volume mount. |
| **Flag 2** | GPO Link Overwrite | DC02 (`192.168.56.11`): `C:\Users\Public\Documents\Shares\flag_2.txt` | **Hard** | AV/AMSI bypass on hardened server core. |
| **Flag 3** | Domain Admin | DC01 (`192.168.56.10`): `C:\Users\Administrator\Desktop\FINAL_FLAG.txt` | **Insane** | ESC13 ADCS PKI exploitation chain. |

---

## ⚡ Quick Deployment

1. Clone the repository:
   ```bash
   git clone https://github.com/ugurkocmen/AD-Extreme-Lab.git
   cd AD-Extreme-Lab
   vagrant up
   vagrant ssh kali
   sudo docker exec -it extreme-app /bin/bash
   ```
Note: If you need to connect manually via external SSH clients directly to the Attacker Machine IP (192.168.56.20), use the default credentials: Username: vagrant | Password: vagrant. Once connected, run "sudo -i" to switch to root context.

   ```bash
   sudo docker exec -it extreme-app /bin/bash
   ```
