install:
	cp src/yubikey-luks.conf /etc/yubikey-luks.conf
	cp src/hooks/yubikey-luks /etc/initcpio/hooks/
	cp src/install/yubikey-luks /etc/initcpio/install/
