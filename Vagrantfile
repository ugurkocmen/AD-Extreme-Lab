Vagrant.configure("2") do |config|
  config.vm.box = "StefanScherer/windows-server-2022-core"

  # --- DC01: PRIMARY DOMAIN CONTROLLER ---
  config.vm.define "dc01" do |dc01|
    dc01.vm.hostname = "DC01"
    dc01.vm.network "private_network", ip: "192.168.56.10"
    dc01.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end
    dc01.vm.provision "powershell", path: "setup/01-init-dc01.ps1"
  end

  # --- DC02: ACTIVE DIRECTORY CERTIFICATE SERVICES (ADCS) ---
  config.vm.define "dc02" do |dc02|
    dc02.vm.hostname = "DC02"
    dc02.vm.network "private_network", ip: "192.168.56.11"
    dc02.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 2
    end
    dc02.vm.provision "powershell", path: "setup/02-init-dc02.ps1"
  end

  # --- ATTACKER: KALI LINUX & LAB ENVIRONMENT ---
  config.vm.define "kali" do |kali|
    kali.vm.box = "kalilinux/kali-rolling"
    kali.vm.hostname = "kali-extreme"
    kali.vm.network "private_network", ip: "192.168.56.20"
    kali.vm.provider "virtualbox" do |v|
      v.memory = 2048
      v.cpus = 1
    end
    kali.vm.provision "shell", path: "setup/03-init-kali.sh"
  end
end
