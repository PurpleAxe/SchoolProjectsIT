# HambaVissie

HambaVissie is a card game that is ripped off the game logic of snap.

## Requirements

Code was written in delphi 2010.
Microsoft Access (For DATABASEs)
dclSockets is required in this project.

## Installing Socket Components 
-> Select Component > Install Packages.
->In the Install Packages dialog box, click Add.
->In the Add Design Package dialog, browse to 
	C:\Program Files (x86)\Embarcadero\Studio\20.0\bin.
->Select dclsockets260.bpl, and click Open.
->Click OK to dismiss Install Packages dialog.

## Getting Started

1.Run ServProj.exe and click Start to initiate the sever.
2.Run ClientProj.exe and click connect

## Run over LAN
1.The machine running the server should have an IPv4 Adress, find it and take note of it.
	-> Windows you can find on Command Prompt with "ipconfig"
2.Give the clients the IPv4 address and change  the IP adress in the client form from 
  "127.0.0.1" to the IPv4 Address.

## Background Notes

This program was written as a school project , there are still many bugs to be fixed.
The game needs to be restarted on both the server and the clients side 
as the game was not finished in time


