<h1>Delphix Masking Splunk Integration</h1>
<h3>Version 1.0</h3>




By [Hims Pawar](https://www.linkedin.com/in/himspawar)


# Table of Contents  
1. [Delphix Masking Splunk Integration](#introduction)  
2. [Introduction](#introduction)  
3. [The Landscape](#landscape)  
4. [Approach 1: Using Splunk Forwarder](#approach1)  
5. [Approach 2 : Direct File Ingestion](#approach2)  

 


<h1>Introduction</h1><a name="introduction"></a>

[Delphix](https://www.delphix.com/) supports log forwarding to SEIM tools like [Splunk](https://www.splunk.com/) or [Sumo logic](https://www.sumologic.com/). The Delphix virtualization logs(metrics / events) can be forwarded [directly](https://docs.delphix.com/docs/configuration/monitoring-and-log-management/splunk-integration) to splunk using a proprietary mechanism called Hypertext Event Collection( HEC) where the Delphix virtualization makes a direct connection via UI. Delphix Masking forwards the logs via API calls that are initiated externally. These calls can be made via a standalone program or via an automated tool like Jenkins or Mulesoft. Delphix API endpoints allow the logs to be fetched in a way that is SEIM(Security Event and Incident Monitoring) solution vendor independent.

<h1>Background to Delphix Logs</h1>

Delphix provides two types of logs. Both of them can be extracted via the API end points. These are:
<ul>
  <li><b>Audit Log:</b> These are the Audit entries regarding system wided access of data.</li>
  <li><b>System Log:</b> These are system activities including user based work </li>
</ul>  


For additional information please refer the following links

1. Delphix Masking Documentation :[here](https://maskingdocs.delphix.com)
1. Delphix Masking Knowledge Base: [here](https://support.delphix.com/Delphix_Masking_Engine)
1. Delphix API guide : [here](https://maskingdocs.delphix.com/Delphix_Masking_APIs/Masking_Client/Masking_API_Client/)

<h1>The Landscape</h1><a name="landscape"></a>

You will need the following components:


Delphix | Splunk
------------ | -------------
Delphix Engine 6.0.8 | Splunk Enterprise 7.2.5



<h1>Approach 1: Using Splunk Forwarder</h1><a name="approach1"></a>

Using Splunk Forwarder

Splunk provides a universal or a lite forwarder agent which is usually present on on any linux or windows boxes in the company. The forwarder captures the logs and then forwards them to a central server. Since Delphix is a secure box, does not allow any additional service or package to be installed(its a black box), forwarder can call the API to get logs in a directory and forward them easily. A script to do this is here https://github.com/suavedude/logging/blob/master/Delphix_getLogs_v1.0.sh

<h2>Illustration</h2>

![Image of Illustration](https://github.com/suavedude/logging/blob/master/pic1.png)

<h1>Approach 2 : Direct File Load</h1><a name="approach2"></a>

This approach uses the “Data input” methods of splunk to invoke an API endpoint and then capture logs. Splunk users can monitor a script and use a variant of above linked script to capture the logs directly as a datasource. It can then be indexed, searched or visualized.

<h2>Step 1</h2>

![Step 1](https://github.com/suavedude/logging/blob/master/approach_1.png)

<h2>Step 2</h2>

![Step 2](https://github.com/suavedude/logging/blob/master/approach_2.png)

<h2>Step 3</h2>

![Step 3](https://github.com/suavedude/logging/blob/master/approach_3.png)

<h2>Step 4</h2>

![Step 4](https://github.com/suavedude/logging/blob/master/approach_4.png)

<h2>Step 5</h2>

![Step 5](https://github.com/suavedude/logging/blob/master/approach_5.png)

<h2>Step 6</h2>

![Step 6](https://github.com/suavedude/logging/blob/master/approach_6.png)

<h2>Step 7</h2>

![Step 7](https://github.com/suavedude/logging/blob/master/approach_7.png)


<h1>Notes</h1>
