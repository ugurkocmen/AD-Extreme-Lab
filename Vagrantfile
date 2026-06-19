Vagrant.configure("2") do |config|
  # Ultra-lightweight Windows Server 2022 Core (No GUI - Multi-VM Optimization)
  config.vm.box = "mikesir87/windows-server-2022-core-amd64"

  # --- DC-01: PRIMARY DOMAIN CONTROLLER ---
  config.vm.define "dc01" do |dc01|
    dc01.vm.hostname = "DC01"
    dc01.vm.network "private_network", ip: "192.168.56.10"
    dc01.vm.provider "virtualbox" do |v|
      v.memory = 1536  # Only 1.5 GB RAM
      v.cpus = 1
    end
    dc01.vm.provision "powershell", path: "setup/01-init-dc01.ps1"
  end

  # --- DC-02: ADCS & IIS ENROLLMENT SERVER ---
  config.vm.define "dc02" do |dc02|
    dc02.vm.hostname = "DC02"
    dc02.vm.network "private_network", ip: "192.168.56.11"
    dc02.vm.provider "virtualbox" do |v|
      v.memory = 1536  # Only 1.5 GB RAM
      v.cpus = 1
    end
    dc02.vm.provision "powershell", path: "setup/02-init-dc02.ps1"
  end

  # --- ATTACKER: KALI LINUX (CLI Only) ---
  config.vm.define "kali" do |kali|
    kali.vm.box = "kalilinux/kali-rolling"
    kali.vm.hostname = "kali-extreme"
    kali.vm.network "private_network", ip: "192.168.56.20"
    kali.vm.provider "virtualbox" do |v|
      v.memory = 1024  # Only 1 GB RAM
      v.cpus = 1
    end
    kali.vm.provision "shell", path: "setup/03-init-kali.sh"
  end
end