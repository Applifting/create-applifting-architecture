# API Contract

* Status: proposed
* Deciders: Jiří Fryč, Tomáš Geržičák
* Date: 2025-01-24

## Context and Problem Statement

We need to define clear way how we will define interface between frontend, backend of corplifting in a way that is non blocking for development of both sides. This contract needs to be adaptable and easily extendable and expect changes in near future.

## Decision Drivers

* Ease of maintaintance
* Extensibility
* Able to be mocked for quick prototyping and testing

## Considered Options

* Contract-first OpenAPI v3.1 definition
* OpenAPI v3.1 definition generated from backend code

## Decision Outcome

Chosen option: "Contract-first OpenAPI v3.1 definition", because not decided yet
