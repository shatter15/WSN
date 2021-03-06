#include <Timer.h>

configuration ACKSenderAppC
{
}
implementation {

  components ACKSenderC,MainC, LedsC;

  components new AMSenderC(AM_MSG);
  components new AMReceiverC(AM_MSG);
  components ActiveMessageC;
  components PrintfC;
  components SerialStartC;

  ACKSenderC.Boot -> MainC;
  ACKSenderC.Leds -> LedsC;
  ACKSenderC.Packet -> AMSenderC;
  ACKSenderC.AMPacket -> AMSenderC;
  ACKSenderC.AMSend -> AMSenderC;
  ACKSenderC.AMControl -> ActiveMessageC;
  ACKSenderC.Receive -> AMReceiverC;
}
