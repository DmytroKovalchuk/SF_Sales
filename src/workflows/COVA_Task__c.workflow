<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>COVA_UniqueProject_Task</fullName>
        <field>COVA_UniqueTaskAndProject__c</field>
        <formula>( COVA_Project__c  &amp;  Name  &amp;  COVA_Consultant__c )</formula>
        <name>COVA_UniqueProject&amp;Task&amp;Contact</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>COVA_UniqueProject%26Task</fullName>
        <actions>
            <name>COVA_UniqueProject_Task</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
