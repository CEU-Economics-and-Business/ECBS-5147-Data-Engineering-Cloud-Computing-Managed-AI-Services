# *Week 1 - Internet*

# Recap Videos

1) [Internet Basics](https://www.youtube.com/watch?v=p7ou-7x2NNE)
2) [Encryption and Digital Signatures](https://www.youtube.com/watch?v=8M1Hxa6pHh8)

# **Basics of Internet, TCP/IP, Servers, Ports, and Firewalls**

## **Protocols**

A protocol is a set of rules or conventions that computers or software use to communicate with each other. These protocols define how data is transmitted, how connections are established and terminated, how errors are detected and corrected, and how devices synchronize their actions. In essence, protocols ensure that different devices can work together seamlessly, even if they come from different manufacturers or use different technologies.

**Real World Example:** Consider a handshake—a protocol with specific rules regarding its length, the positioning of hands, and the politeness of responding or not. Just like people follow social protocols to facilitate effective communication and establish trust, computers rely on established protocols to ensure data is exchanged accurately and efficiently.

Similarly, computers use protocols to transfer data from one place to another.

### Examples of Protocols

1. **HTTP/HTTPS (Hypertext Transfer Protocol/Secure)**  
   These protocols govern how web browsers communicate with web servers. HTTP is the foundation of data communication on the World Wide Web, while HTTPS adds a layer of security through encryption.

2. **FTP (File Transfer Protocol)**  
   FTP is used for transferring files between a client and a server on a network. It specifies how files are formatted, transmitted, and how errors are handled during the transfer process.

3. **SMTP (Simple Mail Transfer Protocol)**  
   SMTP is used for sending emails. It defines the rules for sending messages from an email client to an email server and between email servers.

4. **TCP/IP (Transmission Control Protocol/Internet Protocol)**  
   This fundamental protocol suite governs how data packets are sent and received over the Internet. TCP ensures reliable transmission by establishing a connection, while IP handles the addressing and routing of packets.

5. **DNS (Domain Name System)**  
   DNS protocols translate human-readable domain names (like www.example.com) into IP addresses, enabling browsers to locate and connect to web servers.

### How the Internet Works

When we "go on the Internet" and visit a webpage (e.g., Facebook, Google, Amazon), that webpage understands how to interpret our requests and display the appropriate output.  
Our computer sends information over the Internet to a server owned by the site we’re trying to visit. The server then sends back the necessary information, which the Internet delivers to our computer.  

In essence, the Internet serves as a delivery mechanism for information. But how does it work?

### Internet Protocol Address

Every device on the Internet has an IP (Internet Protocol) address, formatted as `#.#.#.#`, where each '#' is a number that ranges from 0 to 255.  
Like postal addresses, IP addresses uniquely identify devices on the Internet. Any device connected to the Internet has an IP address that allows other devices to communicate with it.  

- **Internet Service Providers (ISPs)** assign an IP address to your computer or router.
- **DHCP (Dynamic Host Configuration Protocol)** is the software that ISPs use to allow devices to request an IP address. DHCP servers respond by assigning a specific IP address to your home network.

Multiple devices can connect to your home network, and the home router supports DHCP by assigning IP addresses to your devices. This setup creates a mini-network with your router acting as a local ISP.  

**IP Address Limitations:**  
In the `#.#.#.#` format, each number is 8 bits, totaling 32 bits, which yields about 4 billion possible addresses. We are running out of addresses for all connected devices.  
The current version of IP addresses is IPv4, but we are transitioning to IPv6, which uses 128 bits and supports an extraordinarily high number of addresses.

### Finding Your IP Address

**Mac:** `MacIP`
![on a Mac](https://ceu-cloud-class.github.io/static/51e6acb733a5928459c113046ef82523/0b533/macip.png)

**Windows:** `WindowsIP`
![on a Windows](https://ceu-cloud-class.github.io/static/5850e7a4b3f13346aad25c26ab05dcef/0b533/windowsip.png) 

**Private IP Addresses:**  
Private IP addresses are formatted as `10.#.#.#`, `192.168.#.#`, or `172.16.#.#` – `172.31.#.#` (`172.16.0.0/12`). These addresses require special configurations for external access (i.e. for someone to 'talk' to your computer).  
Your personal device is not a server; it doesn't need to be accessed directly. Instead, it requests data from servers. For instance, email is stored on servers like Gmail, and your device makes a request to access that email.

### Advanced Settings

A **subnet mask** determines whether another computer is on the same network, though this is beyond our current focus.  
A **router** (also known as a gateway) has its own IP address and routes data in different directions.

## **DNS**

We access websites using domain names (e.g., facebook.com, google.com), but these names correspond to IP addresses.  
**DNS (Domain Name System)** is a system that translates human-readable domain names into their IP address counterparts. It allows us to navigate from point A to B effectively.  

Routers or gateways receive information, check its destination, and send it to the appropriate router. Data doesn’t have to follow the same path each time, but it usually makes around 30 hops from router to router.

### Summary of DNS

In summary, DNS converts domain names into IP addresses.

## **Packets**

Computers communicate by sending **packets**, which are like virtual envelopes containing data. The data is ultimately represented as binary code (0s and 1s).  
**Analogy:** Suppose we want to find a `ceu_logo` image on the Internet. We send a request to a server (e.g., Google) saying, “get ceu_logo.jpg.” We place this request in an envelope, listing our IP as the return address.  

However, we don’t know Google's IP address, so we rely on DNS to retrieve it. If our ISP's DNS server doesn’t have the IP address, it will ask another DNS server.  
Root servers exist to know where to look for IP addresses. After sending the request, we receive a response in milliseconds.

### Sending the `ceu_logo`

![](https://ceu-cloud-class.github.io/static/65fd2392795c05ad09026b1ed87d0e34/7cc5e/ceulogo.jpg)

The `ceu_logo` will be sent back in one or more packets.  
If the image is too large for a single packet, Google divides it into smaller fragments and sends them in separate envelopes, detailing the return address (Google’s IP) and the delivery address (our IP). Each envelope lists the packet sequence (e.g., 1 of 4, 2 of 4, etc.).

## **TCP/IP**

How do we ensure that data, even in large quantities, reaches its destination fairly? How do we send data while ensuring that the recipient knows how to process it?  
One solution is to label the data sequentially so the recipient can reconstruct the correct order. Additionally, if some data is lost during transmission, TCP (Transmission Control Protocol) allows us to request the missing data. TCP is commonly used with IP.

### IP's Role

IP goes beyond addressing; it provides a set of conventions for intercommunication between computers and servers. Fragmentation, as in our envelope example, is supported by IP.  
If a packet is missing, the recipient can infer which one is missing based on the received packets. However, IP alone doesn't dictate what to do in such cases.

### TCP's Functionality

TCP ensures packets reach their destination. It is commonly used alongside IP (TCP/IP) and supports sequence numbers to facilitate proper data assembly.  
When a packet is missing, a computer can request the missing one, allowing for complete file assembly. TCP also includes conventions for requesting services through port identifiers, ensuring that requests are directed to the appropriate services.

For example, data headed to `#.#.#.#:80` indicates that the data should be sent to `#.#.#.#` through port 80, which is the standard port for HTTP (web requests).

## **Ports**

Through TCP, standardized port numbers represent various services.  
If `5.6.7.8` is Google’s IP address, `5.6.7.8:80` signifies a request for a webpage using HTTP (Hypertext Transfer Protocol).  

Google processes this request via their web server. Many websites use secure connections with SSL or HTTPS, which utilizes port 443. Email services typically use port 25, among others.

## **UDP (Optional)**

**User Datagram Protocol (UDP)** is a counterpart to TCP that does not guarantee delivery.  
UDP is often used for real-time applications like video conferencing (e.g., FaceTime), where packets can be dropped to maintain fluidity. It is suitable for scenarios where continuous data flow is preferred over waiting for all packets to arrive.

## **Routers**

Routers have numerous wires connecting them to other devices. They maintain a large table of IP addresses to determine how to route data to its destination.  
The primary function of a router is to direct data toward the correct destination, passing it to the next router until it reaches its final destination.

![](https://upload.wikimedia.org/wikipedia/commons/2/2b/XO_classroom_network.jpg)

# Understanding the Internet and Protocols

The Internet is a network of networks, each with its own routers. There are often multiple ways to go from point A to point B, based on US military logic to prevent downtime if a particular router goes down.

When multiple packets, like `ceu_logo.jpg` from Google, are sent, they can each take a different path, still reaching their destination eventually. Sometimes the Internet gets busy, causing the quickest path to change.

## Traceroute

[Video internet crash course](https://www.youtube.com/watch?v=AEaKrq3SpW8)


Traceroute literally traces the route that information takes from our computer to a destination. It allows us to see which routers are being used by data to reach its destination. This route may change over time and according to web traffic patterns.

### How long does data transfer take on the Internet?

Traceroute is a program that sends packets to each router on a path to a destination, reporting the time it takes to reach each router. 

- **Mac (Terminal)**: `traceroute domainname.com`
- **Windows**: `C:\>tracert www.example.com`
- **Linux / Codespaces**: `traceroute domainname.com` (if `traceroute` or `nslookup` is missing, install them with `sudo apt-get install -y traceroute dnsutils`)

### Example Traceroute Results

**From Sanders Theatre to Berkeley.edu:**
![](https://ceu-cloud-class.github.io/static/dcd9fed7be145fec7c1c106f8cf28b15/ecf19/traceroute1.png)

6: Northern Crossroads
7-14: A fast connection
8-9: Chicago
10-11: Denver
12-13: Las Vegas
4: Los Angeles
19 is where it arrives at Berkeley in 80 ms!


![](https://ceu-cloud-class.github.io/static/27fe963aacf917d804db2a688a180e9c/5a190/traceroute2.png)

9-10 jumps from Seattle to Osaka past an ocean!

Using undersea cabling!

# Undersea Cabling

We can also use traceroute to access international destinations, especially those on different continents. A vast network of cabling connects locations across oceans, including the Pacific and Atlantic.

[Earth looks like a MOTHERBOARD](https://www.youtube.com/watch?v=IlAJJI-qG2k)

## HTTP - Hypertext Transfer Protocol

HTTP is a very common protocol that you’ve likely seen before, such as in the URL [http://example.com](http://example.com). It acts as a virtual envelope, allowing computers to communicate with each other, specifically in the context of web pages (i.e., between web browsers and servers).

We can use the `nslookup` command to check the IP address of a web domain, for example:
```bash
nslookup www.facebook.com
```
We can also simulate a browser request to see the response when visiting a webpage using (replace the IP with the one `nslookup` returned for you):

```
curl -I http://<IP-from-nslookup>/
```

Facebook answers with a `301` (redirect) status and a `Location` header: this tells us that Facebook would prefer we use their domain name, which specifies which type of HTTP to use.

In general, a successful response returns 200, indicating that everything is okay. Conversely, a 404 response indicates that something didn't go as planned. The information we receive is referred to as headers, which provide additional data about the response.

## HTML - Hypertext Markup Language

Using curl without the -I flag allows us to see the HTML results or the data returned from a server. HTML instructs the browser on how to display content, including the placement of images and text formatting.

[Summary video](https://www.youtube.com/watch?v=guvsH5OFizE)

## Security and Privacy
Our data is under constant threat, but how can we defend ourselves? Here are some key points to consider:

- **Access Control:** It's crucial to keep unauthorized individuals away from sensitive information.
- **Device Security:** Computers are among the least secure devices you own. Data or files are stored as 0s and 1s and can include financial information, photos, and more.

---

## Cookies

Cookies are a feature supported by HTTP. They are small data values that a web server places in a user’s browser, allowing the server to remember if a user has visited the site before. Here’s how they work:

- **Login Persistence:** Cookies allow you to remain logged in without needing to enter your credentials every time you visit or refresh a page.
- **Session Management:** When you log into a web server, a cookie is created and stored in a database. The browser sends this cookie back to the server to remember your previous login.

### Example of Request and Response

When we make a request, we send:
```http
GET / HTTP/1.1
Host: example.com
```
In response, we might receive:
```http

HTTP/1.1 200 OK
Set-Cookie: session=29823bf3-075a-433a-8754-707d05c418ab
```

# Cookies and Security

A cookie is similar to an ink-based hand stamp used at amusement parks or clubs. It identifies users and their sessions, but there are significant security concerns:

- **Interception Risks:** Wireless information can be intercepted, leading to potential vulnerabilities.
- **Session Hijacking:** If a hacker obtains your cookie, they can impersonate you if you are already logged in. Encryption helps scramble this value, making it difficult for hackers to exploit.

### Browser History

Your browser history remembers every website you've visited and the activities you've done there. While this feature is convenient for recalling sites, it has privacy implications:

- **Accessibility:** Anyone with access to your browser can see this history.
- **Clearing History:** You can clear your browser history and cookies, but it’s likely that the history isn’t securely scrubbed. This action will protect you from nosy friends and will cause websites to forget your visits since the cookies will be deleted as well.

---

## Firewall

A physical firewall is a barrier between connected buildings that prevents the spread of fire. In computer science, a firewall is software that monitors IP addresses, helping to keep unauthorized users out and user data secure. It plays a critical role in preventing people from accessing your computer.

---

## Encryption

### Symmetric Encryption: Caesar Cipher

Let's consider a simple example: if I want to send the message "HI," instead of sending "H-I," I might send "I-J" across the Internet. 

**Transformation:**

HI ➟ IJ

For the recipient to decode this message, they need to understand the secret algorithm used to shift the letters, along with the key—specifically, the number of places the letters have been shifted. In this case, the key is `1`, which is relatively easy to guess.

- This transformation creates what is known as **cipher text**, which can be decrypted back into **plain text**.
  
**Example:**
- Plaintext ➟ Ciphertext ➟ Plaintext

HI ➟ IJ ➟ HI

This method is known as a **Caesar cipher**, a type of rotational cipher. 

### Security Limitations

- Rotational ciphers are not very secure and can be easily guessed, which is why they are not suitable for Internet encryption.
- For the recipient to successfully decrypt the message, they must know the key in advance. However, this poses a challenge, as we cannot send the key securely if we haven't agreed on it before.

---

### Public Key Cryptography (PKI)

The Caesar cipher example demonstrates secret-key cryptography, which relies on a single key. This creates a "chicken-and-egg" problem: how can both parties agree on a key without a secure channel? 

For instance, if I can't send a message with the key `1` unencrypted, I could call them to discuss it. However, if I’m already using another channel to communicate, I could just share the message directly.

This situation is similar when you visit a website. You don’t personally know anyone at amazon.com or Gmail; you only know their domain names.

In secret key cryptography, maintaining the secrecy of the key is crucial. Public key cryptography addresses the challenges associated with this:

- **Two Keys:** In public key cryptography, each person has two keys: one private and one public.
- **Encryption and Decryption:** The public key is used to encrypt information, while the private key is used to decrypt it.

[What is Public Key Infrastructure (PKI) by Securemetric](https://www.youtube.com/watch?v=i-rtxrEz_E8)

#### Example: Alice and Bob

- **Alice** has a private key (A) and a public key (public A).
- **Bob** has a private key (B) and a public key (public B).

When Alice wants to send Bob a message, she uses Bob's public key to encrypt it. Upon receiving the message, Bob decrypts it with his private key.

- There is a mathematical relationship such that Bob's private key can reverse the effects of Bob's public key.
  
When Bob wants to reply to Alice, he uses Alice's public key. Alice then decrypts the message with her private key. The public keys (A and B) can be shared openly, even on the Internet or over the phone, while the private keys must remain confidential.

### Browser Implementation

All of this occurs automatically in today's browsers. When your browser (like Chrome or Edge) connects to websites such as amazon.com or gmail.com, the server presents its certificate (containing the server's public key, signed by a trusted certificate authority), and the browser and server then agree on a fresh shared secret using an ephemeral (EC)DHE key exchange. In normal TLS the browser does not need its own public and private keys. 

Your browser employs this public key cryptography system to securely exchange messages with companies like Amazon, Google, or Facebook, even though your device has never met anyone from those organizations.

For efficiency, secret key cryptography is often utilized later in the communication process.

### HTTPS and Secure Communication

Encrypted web communication is somewhat more complex than it appears. Initially, a public-key-based secure channel is established. Next, your browser and the server agree on a symmetric cryptography method and key over this secure channel. 

Once this agreement is made, the PKI communication phase concludes, and symmetric encoded communication continues.

For further reading, check out this article: [How HTTPS Works: RSA Encryption Explained](https://tiptopsecurity.com/how-does-https-work-rsa-encryption-explained/).

# Public Key Infrastructure (PKI)

## Illustration of PKI

In public key cryptography, there are two keys: one public and one private. These keys are mathematically related. You use the public key to encrypt data and the private key to decrypt it.

- **Key 1:** Bob’s private key can undo the effects of his public key.
- **Key 2:** When Bob responds, he sends a message using Alice’s public key.

Both your browser and websites like Google and Amazon have their own public and private keys, allowing them to communicate securely. This process is used to exchange a secret key, enabling continued communication using symmetric encryption with the exchanged secret key.

---

## Certificates and Digital Signatures

### Certificates

Public key cryptography secures web traffic through the SSL/TLS protocol, which is utilized when you access URLs that begin with `https://`. The level of security achieved through this protocol is significant.

Regardless of whether you use a Mac or PC, your operating system comes with a few public keys installed that are common for users worldwide. These public keys are trusted to be authentic. Public keys, along with additional information such as the issuer and expiration date, are known as certificates. 

Certificates are provided by root Certificate Authorities (CAs), which are a select number of qualified companies. If you want to communicate with Amazon.com, you may not know Amazon's correct public key, but a trusted CA will. For instance, a CA might issue a signed message stating:

> “I, a CA, certify that the public key of Amazon.com is:  
> 30 82 01 0a 02 82 01 01 00 94 9f 2e fd 07 63 33 53 b1 be e5 d4 21 9d 86 43 70 0e b5 7c 45 bb ab d1 ff 1f b1 48 7b a3 4f be c7 9d 0f 5c 0b f1 dc 13 15 b0 10 e3 e3 b6 21 0b 40 b0 a3 ca af cc bf 69 fb 99 b8 7b 22 32 bc 1b 17 72 5b e5 e5 77 2b bd 65 d0 03 00 10 e7 09 04 e5 f2 f5 36 e3 1b 0a 09 fd 4e 1b 5a 1e d7 da 3c 20 18 93 92 e3 a1 bd 0d 03 7c b6 4f 3a a4 e5 e5 ed 19 97 f1 dc ec 9e 9f 0a 5e 2c ae f1 3a e5 5a d4 ca f6 06 cf 24 37 34 d6 fa c4 4c 7e 0e 12 08 a5 c9 dc cd a0 84 89 35 1b ca c6 9e 3c 65 04 32 36 c7 21 07 f4 55 32 75 62 a6 b3 d6 ba e4 63 dc 01 3a 09 18 f5 c7 49 bc 36 37 52 60 23 c2 10 82 7a 60 ec 9d 21 a6 b4 da 44 d7 52 ac c4 2e 3d fe 89 93 d1 ba 7e dc 25 55 46 50 56 3e e0 f0 8e c3 0a aa 68 70 af ec 90 25 2b 56 f6 fb f7 49 15 60 50 c8 b4 c4 78 7a 6b 97 ec cd 27 2e 88 98 92 db 02 03 01 00 01”

This message is known as a **certificate**. Parts of this certificate are encrypted using the CA's private key, allowing anyone to decrypt it with the CA's public key and validate that the certificate was indeed "signed" by the CA. This method extends your trust in the Certificate Authorities to your trust in Amazon.

The real-world situation is slightly more complex, as CAs can also issue certificates to other CAs, which can then certify websites. This creates a chain of certificates and, consequently, a chain of trust. For more details, check out this explanation: [DigiCert Knowledge Base](https://knowledge.digicert.com/solution/SO16297.html).

When your browser communicates with Amazon, it can request this certificate. If the certificate is not present, the interaction will not proceed. A potential attacker could block this message from traveling but cannot spoof the message or send a certificate for their own public key unless they possess a CA's secret key.

Using certificates, we assume that Bob, the user, has the public verification key \(v\) of Alice, the server. Alice can also send Bob a public encryption key \(e\), which is authenticated by \(v\) and thus guaranteed to be correct. Once Bob knows Alice’s public key, he can use it to encrypt a private key \(k\) for their ongoing communication.

### What if a Root CA's Secret Key Gets Exposed?

In the event that a Root CA's secret key is compromised, it would likely lead to a significant crisis. Companies like Apple and Microsoft would need to issue urgent updates to their operating systems to prevent any computer from trusting certificates originating from the compromised CA.

---

## Digital Signatures

Digital signatures and other forms of electronic signatures are legally binding in many jurisdictions. Below are some details from the electronic signing company DocuSign:
![DocuSign](https://ceu-cloud-class.github.io/static/3b3e0d5fac5c6a6cd484db66135913e1/913b9/docusign.png)

### Components of Digital Signatures

Digital signatures consist of two key components:

1. **Valid Certificate:** As the signer, you must have a valid certificate. You can obtain this certificate by visiting a CA's office with your ID, where you will receive your private key and a certificate containing your public key. Importantly, the certificate itself does not contain any sensitive information.

2. **Signing Documents:** To sign documents, you encrypt a hash of the document with your private key. This creates a signature, which consists of the encrypted hash and your certificate. You do not encrypt the entire document; instead, you only encrypt its hash.

### Signature Validation Process

When someone receives a document with your signature, they verify it through the following steps:

1. **Validate the Certificate:** First, they check the validity of your certificate.
2. **Decrypt the Hash:** Next, they decrypt the hash using your public key. If this decryption is successful, it confirms that the hash was signed by you.
3. **Compare Hashes:** The receiver then hashes the document themselves and compares it to the decrypted hash. If both hashes match, they can be certain that the document has not been altered since you signed it.

---

## Q&A

### 1. Explain the Process of Visiting a Website

Suppose you turn on your computer and visit `https://www.ceu.edu/`. Here's how the process works:

When I turn on my computer and connect to WiFi, the DHCP server assigns me a unique IP address and provides the IP address of the local DNS server. The DNS server converts domain names to IP addresses. When I type `www.ceu.edu`, the DNS translates it into a numeric address—the actual location of the server hosting the website. An HTTP request is then sent to this server, which responds by sending a copy of the website (data) to me via TCP/IP. If the request is approved, data packets will be transmitted to me, which will then be assembled and displayed on my screen.

- **DHCP Server:** Assigns IP addresses.
- **DNS Server:** Contains the IP addresses and hostnames for translation.
- **IP Address:** Format is #.#.#.#, where each # is between 0 and 255 (identification & location).
- **Packet:** A unit of data.
- **TCP Port:** Identifies the requested format; for example, port 80 requests web services, while port 25 requests email.
- **Web Server:** Processes incoming network requests over HTTP and other protocols.

### 2. Why Might Packets Be Lost?

Packets may be lost due to malfunctions, technical difficulties, or overloaded routers. TCP ensures reliable delivery by retransmitting any lost packets.

### 3. What is UDP?

UDP does not guarantee delivery. If some data is lost, packets are simply dropped without retransmission. This protocol is useful for applications like Skype, streaming, and video games, where it is preferable to skip a few seconds of data rather than suffer constant lag.

### 4. How Does a Server Identify the Type of Packet?

When a server receives a packet, it determines the packet type based on the port number specified in the packet's 'envelope'. This port number indicates the type of information contained within.

### 5. How Does a Website Know Your IP Address?

The web server requires your IP address to establish a connection and communicate effectively. Anonymization methods such as proxies, VPNs, Tor, and firewalls can be employed to mask your IP address. Knowing someone's IP address can reveal their approximate location based on their ISP, and websites often log IP addresses to serve relevant advertisements.

---

## Practice Questions

1. Explain what an IP address is and how it relates to the DNS system and hostname.

2. What does it mean if a URL begins with `https://` as opposed to `http://`? How does this relate to ports?

3. What is symmetric encryption? Explain how Caesar encoding works. What are the challenges of using symmetric encryption if the parties have never met before?

4. How does Public Key Cryptography work? Explain the concept of the two types of keys and their relationship.

5. How do digital signatures work? Describe the signing and signature validation processes.

6. How does HTTPS work? Explain the processes of identification validation and encryption.


# Sources

1. [Web Server - Webopedia](https://www.webopedia.com/TERM/W/Web_server.html)
2. [Lecture 10: Network Protocols - Stanford University](http://web.stanford.edu/class/cs101/lecture10.html#/4)
3. [Introduction to Public Key Cryptography - Boaz Barak](https://www.boazbarak.org/cs127spring16/chap10_public_key_intro.pdf)
4. [Public Key Encryption Definition - Intense Crypto](https://intensecrypto.org/public/lec_10_public_key_intro.html#sec-public-key-encryptions-definition)
5. [Heartbleed: A Critical Vulnerability in OpenSSL - Jhalderm](https://jhalderm.com/pub/papers/heartbleed-imc14.pdf)
6. [Internet Overview - Stanford University](https://web.stanford.edu/class/cs101/network-2-internet.html)
7. [What Happens When You Type a URL in the Browser - Medium](https://medium.com/@maneesha.wijesinghe1/what-happens-when-you-type-an-url-in-the-browser-and-press-enter-bb0aa2449c1a)
8. [CS50 Publications - Harvard University](https://cs.harvard.edu/malan/publications/)
9. [What is DNS Hijacking? - Wired](https://www.wired.com/story/what-is-dns-hijacking/)
10. [Internet White Paper - Stanford University](https://web.stanford.edu/class/msande91si/www-spr04/readings/week1/InternetWhitepaper.htm)
11. [CS50 Course - Harvard University](https://cs50.harvard.edu/college/)
12. [Introduction to Networking - Stanford University](https://web.stanford.edu/class/cs101/network-1-introduction.html)
13. [YouTube Video: CS50 - How Computers Work](https://www.youtube.com/watch?v=AEaKrq3SpW8)
14. [Computer Science Courses - Harvard SEAS](https://www.seas.harvard.edu/academics/courses/computer-science)
15. [Caesar Cipher - Wikipedia](https://en.wikipedia.org/wiki/Caesar_cipher)
16. [YouTube Video: The Basics of Cryptography](https://www.youtube.com/watch?v=guvsH5OFizE)
17. [YouTube Video: Introduction to Computer Networking](https://www.youtube.com/watch?v=IlAJJI-qG2k)
18. [Intro to Computer Science - Intro to CS](https://introtcs.org/public/index.html)
19. [Dynamic Host Configuration Protocol - Wikipedia](https://en.wikipedia.org/wiki/Dynamic_Host_Configuration_Protocol)

