# Campus Equipment Manager

## Overview

Campus Equipment Manager is an iOS application designed for university student clubs that manage shared equipment.

The application helps an equipment officer track equipment availability, record loans, identify overdue equipment, and process equipment returns in one place.

## Problem Context

University student clubs may share cameras, microphones, projectors, tripods, and other equipment between members. When loan information is recorded across messages, spreadsheets, or notes, it can become difficult for an equipment officer to determine:

- which equipment is currently available;
- who has borrowed an item;
- when an item is due;
- which equipment is overdue; and
- when returned equipment becomes available again.

This application provides a central workflow for managing these equipment loans.

## Stakeholder

The primary stakeholder is a university student club equipment officer.

The application supports the officer's workflow from equipment registration and availability checking through borrowing and returning equipment.

## Main Features

- View equipment availability.
- Add new equipment.
- Record equipment loans.
- Set loan due dates.
- View current equipment loans.
- Identify overdue loans.
- Process equipment returns.
- Share equipment information into the application.
- View overdue and due-today information through an iOS widget.

## Architecture

The application uses a domain-centred architecture with a Repository layer.

```text
SwiftUI Views
      |
ViewModels
      |
Use Cases
      |
EquipmentRepository
      |
CoreDataEquipmentRepository
      |
Core Data