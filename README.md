# Yubikey LUKS - Challenge/Response for LUKS (on Arch Linux)

## Description

Based off [yubikey-full-disk-encryption](https://github.com/agherzan/yubikey-full-disk-encryption), with modifications.

This project enables unlocking of LUKS partitions using a [yubikey](https://www.yubico.com). It uses initramfs to do this and mkinitcpio to generate it (the initramfs).

Be aware that this was only tested and intended for:
* Archlinux
* YubiKey 4

## LUKS partition configuration

In order to unlock the encrypted partition, this project relies on a yubikey in challenge-response HMAC mode. The challenge is entered at boot as a passphrase while the response is one (or the only) password used in the LUKS key slots.

First of all we need to set a configuration slot in challenge-response HMAC mode using a command similar to:

```
ykpersonalize -v -1 -ochal-resp -ochal-hmac -ohmac-lt64 -ochal-btn-trig -oserial-api-visible
```

Make sure you customize the above line with the correct slot you want to set. I use `-ochal-btn-trig` to force touching the device before releasing the response.

Set the challenge...

```
read -s challenge
```

... and get the response:

```
ykchalresp "$challenge"
```

Use the response as a new key for your LUKS partition:

```
cryptsetup luksAddKey /dev/<device>
```

## Initramfs hooks instalation and configuration

Install all the needed scripts by issuing:

```
sudo make install
```

Edit the /etc/yubikey-luks.conf file.

Add the `yubikey-luks` HOOK at the end of the definition of `HOOKS` in /etc/mkinitcpio.conf.

Regenerate initramfs:

```
sudo mkinitcpio -p linux
```

Reboot and test you configuration.
