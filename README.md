<h1>Delphic Masking Splunk Integration</h1>
<h3>Version 1.0</h3>




By [Hims Pawar](https://www.linkedin.com/in/himspawar)



Table of Contents
Delphic Masking Splunk Integration	1
Introduction	3
The Landscape	3
Approach 1: Using Splunk Forwarder	3
Approach 2 : Direct File Ingestion	3

 


<h1>Introduction</h1>

[Delphix](https://www.delphix.com/) supports log forwarding to SEIM tools like [Splunk](https://www.splunk.com/) or [Sumo logic](https://www.sumologic.com/). The Delphix virtualization logs can be forwarded directly to splunk using a proprietary mechanism called Hypertext Event Collection( HEC) where the Delphix virtualization makes a hIn earlier versions of Delphix Maskyyps based connection to the splunk installation and forwards the logs.

Delphix masking logs are consumed by application in a slightly different way. Delphix APi end points allow the logs to be fetched in a way which is SEIm log vendor independent.

<h1>Background to Delphix Logs</h1>

Delphix provides two types of logs. Both of them can be e exgracted via the API end points. These are 
Audit Log: These are the Audit entries regarding system wided access of data.
System Log: These are system activities including user based work 


For additional information please refer the following links

1. Delphix Masking Documentation :[here](https://maskingdocs.delphix.com)
1. Delphix Masking Knowledge Base: [here](https://support.delphix.com/Delphix_Masking_Engine)
1. Delphix API guide : [here](https://maskingdocs.delphix.com/Delphix_Masking_APIs/Masking_Client/Masking_API_Client/)

<h1>The Landscape</h1>

You will need the following components:


Delphix | Splunk
------------ | -------------
Delphix Engine 5.3.x | Splunk Enterprise 7.2.5



<h1>Approach 1: Using Splunk Forwarder</h1>

Using Splunk Forwarder

<h2>Illustration</h2>

![Image of Illustratiobn](https://github.com/suavedude/logging/blob/master/pic1.png)

<h1>Approach 2 : Direct File Load</h1>

This approach uses the “Data input” methods of splunk to invoke an API endpoint and then capture logs.




<h1>Notes</h1>






















Points to Note
