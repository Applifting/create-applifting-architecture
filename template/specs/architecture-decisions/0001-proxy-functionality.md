# Proxy Functionality

* Status: proposed
* Deciders: Jiří Fryč, Tomáš Geržičák
* Date: 2025-01-24

## Context and Problem Statement

We need to decide on proxy functionality so we can easily release frontend components and backend modules without direct dependencies on each other

## Decision Drivers

* Feature flagging is possible
* Ability to switch part of application between old and new corplifting

## Considered Options

* Kotlin based proxy with feature flagging and two levels of proxing (views and api)
* Nginx based proxy with feature flagging and two levels of proxing (views and api)

## Decision Outcome

Chosen option: "Kotlin based proxy with feature flagging and two levels of proxing", because not decided yet
