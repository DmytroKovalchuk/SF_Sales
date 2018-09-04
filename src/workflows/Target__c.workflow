<?xml version="1.0" encoding="UTF-8"?>
<Workflow xmlns="http://soap.sforce.com/2006/04/metadata">
    <fieldUpdates>
        <fullName>createUniqueName</fullName>
        <field>unique__c</field>
        <formula>Representative__c  &amp;  Customer__c</formula>
        <name>createUniqueName</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <fieldUpdates>
        <fullName>uniqueUpdate</fullName>
        <field>unique__c</field>
        <formula>Name</formula>
        <name>uniqueUpdate</name>
        <notifyAssignee>false</notifyAssignee>
        <operation>Formula</operation>
        <protected>false</protected>
    </fieldUpdates>
    <rules>
        <fullName>uniqueUpdate</fullName>
        <actions>
            <name>createUniqueName</name>
            <type>FieldUpdate</type>
        </actions>
        <active>true</active>
        <description>this rule update unique field with the name of the object</description>
        <formula>true</formula>
        <triggerType>onAllChanges</triggerType>
    </rules>
</Workflow>
