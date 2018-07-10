# WordPress Updater

This project is an early beta of WordPress updates script. The script loops through the websites in specific folder and updates all WordPress elements via WP CLI. 
It is very useful for development environment or staging servers where you can update all of the websites for testing. The file is permission friendly - it maintains file permissions that it met at the beginning, however, only globally (the parent's folder permissions)


### Requirements

The script requires:
  - Bash > 4
  - [WP CLI](https://wp-cli.org/)
  - Mail command (In ubuntu mailutils package)
  - User with sudo permissions

### Installation

Copy updater.sh file to your home directory (the last parameter is folder name, you can name it in any way you want)
```sh
$ git clone https://github.com/futurelabnz/wordpress-updater.git wpu
```

Change updater file so it's executable 
```sh
$ chmod +x ~/wpu/updater.sh
```

If you want to send confirmation after update, create a config file in your website main folder

```sh
$ cp ~/wpu/example_updater.conf /var/www/website.com/updater.conf
```
### Usage

```sh
$ ~/wpu/updater.sh
```
***And see the magic happens***