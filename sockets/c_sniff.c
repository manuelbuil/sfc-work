#include <sys/socket.h>
#include <linux/if_packet.h>
#include <linux/if_ether.h>
#include <linux/if_arp.h>
#include <stdio.h> 
#include <string.h>
 
/* 
    96 bit (12 bytes) pseudo header needed for tcp header checksum calculation 
*/
struct pseudo_header
{
    u_int32_t source_address;
    u_int32_t dest_address;
    u_int8_t placeholder;
    u_int8_t protocol;
    u_int16_t tcp_length;
};
 
/*
    Generic checksum calculation function
*/
unsigned short csum(unsigned short *ptr,int nbytes) 
{
    register long sum;
    unsigned short oddbyte;
    register short answer;
 
    sum=0;
    while(nbytes>1) {
        sum+=*ptr++;
        nbytes-=2;
    }
    if(nbytes==1) {
        oddbyte=0;
        *((u_char*)&oddbyte)=*(u_char*)ptr;
        sum+=oddbyte;
    }
 
    sum = (sum>>16)+(sum & 0xffff);
    sum = sum + (sum>>16);
    answer=(short)~sum;
 
    return(answer);
}
 
int main (void)
{
    //Create a raw socket
    int on = 1;
    int s = socket(AF_PACKET, SOCK_RAW, htons(ETH_P_ALL));
    if (s == -1) {
        perror("socket() failed");
        return 1;
    }else{
        printf("socket() ok\n");
    }
 
    if(s == -1)
    {
        //socket creation failed, may be because of non-root privileges
        perror("Failed to create socket");
	return 1;
    }
 
    //Datagram to represent the packet
    char eth_frame[ETH_FRAME_LEN];
 
    while (1)
    {
        //Send the packet
	int length = recvfrom(s, eth_frame, ETH_FRAME_LEN, 0, NULL, NULL);
	if (length < 0)
        {
            perror("sendto failed");
        }
        //Data send successfully
        else
        {
		unsigned char dest_mac[6];
		unsigned char src_mac[6];
		unsigned char packet_id[2];
		unsigned char buffer[ETH_DATA_LEN];
 
		memcpy(dest_mac, eth_frame, ETH_ALEN);
		memcpy(src_mac, (void*)eth_frame+ETH_ALEN, ETH_ALEN);
		memcpy(packet_id, (void*)eth_frame+(ETH_ALEN*2), ETH_ALEN);
		memcpy(buffer, (void*)eth_frame+ETH_HLEN, ETH_DATA_LEN);
 
		int i=0;
		printf("dest_mac: ");
		for(i=0; i<ETH_ALEN; i++)
			printf("%.2x:", dest_mac[i]);
 
		printf(", src_mac: ");
		for(i=0; i<ETH_ALEN; i++)
			printf("%.2x:", src_mac[i]);
 
		printf(", packet_id: ");
		for(i=0; i<2; i++)
			printf("%u:", packet_id[i]);
		/*
		printf(", data: ");
		for(i=0; i<ETH_DATA_LEN; i++)
			printf("%.2x", buffer[i]);
		*/
 
		printf("\n");
        }
    }
 
    return 0;
}
