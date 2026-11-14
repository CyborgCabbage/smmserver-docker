This is a modification of mrexodia's https://github.com/SmmServer/SmmServer
that runs a docker container for a real Wii U to connect to.

It is currently untested!

Requirements;
- A modded Wii U
- Any computer that can run docker (any OS)
- Some basic understanding of how to use a command prompt/terminal This
  server will turn whatever computer you set this up on into a pretendo
  DNS proxy server. This means that every time you open Super Mario
  Maker 1, you will need this computer running as well as the docker
  container. You can do this on your primary machine without issue, but
  if you have a second computer laying around it might be better to use
  that instead. This guide also assumes you're using Windows, but the
  instructions are comparable to Linux/Mac as well.

The computer that you will need to use the local port 53, on Windows
it's something required by some Hyper-V services. We're going to disable
this and replace it. Follow the instructions in the given link to
disable these services;
https://learn.microsoft.com/en-us/answers/questions/3753205/solved-unable-to-stop-internet-connection-sharing?forum=windows-all&referrer=answers

First things first, you will need docker installed and running. Go do
docker's website and follow instructions for installing.

Next, open a command prompt. Type this command to ensure docker is
installed and running;

```
docker
```

You should get a long list of commands that can be run. If you get an
error, docker is not set up properly.

Next, place the `smmserver-docker-image.tar` file as-is somewhere on
your computer (don't unzip it). This folder is temporary, so you can
just create the folder on your desktop.

Open a command prompt/terminal in the folder that you created. On
Windows, right click inside the folder in Explorer and click "Open in
Windows Terminal". Next, we will run a couple commands. Run each command
one at a time, ensuring there are no errors each time.

```
docker import smmserver.tar smmserver:latest docker run -p53:53/udp -p53:53/tcp -p8000:8000 --name smmserver -d smmserver:latest
```

In your browser, visit `localhost:8000`, and you should see a very simple
website, "Directory listing for /". If you see this site, congrats,
that's 90% of the hard part done.

Click on the "wii-u-certificates" link, and download all these files,
put them all in a temporary folder. Every file (except README.txt) will
need to go into the Wii U system store

`mlc01/sys/title/0005001b10054000/content/scerts/`

using a homebrew app. You can use "FTPiiU Everywhere".

https://consolemods.org/wiki/WiiU:FTPiiU_Everywhere

You will then need to modify you Wii U's connection settings. This is
done without homebrew. Go to
```
System Settings ->
    Internet ->
    Connect to the Internet ->
    (select active connection) ->
    Change Settings ->
    DNS ->
        (select Don't Auto-Obtain)
        Primary DNS: Local IP of your computer (192.168.x.x)*
        Secondary DNS: 1.1.1.1 (fallback to normal DNS server)
```

Save any changes.

*To get the local IP of your windows machine, run this command in a
command prompt;

```
ipconfig | find "IPv4" | find /V "192.168." | CLIP
```

Theoretically, all should be working. Open up Mario Maker 1 and see what
happens!
