# Object-Oriented Programming Concepts

## 1. Methods

Methods represent the operations that can be performed by a particular data type: a Class;

In order to define a method for a particular java Class, you have to declare it through a set of mandatory and oprional attributes (table for all the foowing?!)

Manatory attributes are Access modifiers: described in chapter (I put the link after: already described in the link. no need to explain more), the method signature, the return type and the method body.

Optional attributes are: static, abstract, final, default, synchronized, native, strictfp, exception list

Optional modifiers can appear in any order but must appear all before return type

Return type: it must appear right before the method name; it specify the type of variable returned by the method; void must be specified if the method does not return a value.
method with a return type other than void must have a return statement inside the body.
method vith void may omit that or provide a return statement with no value;

Method name: follow the same rules for identifiers described in (I put the link after).
Method signature: composed of method name and parameter list, separated by commas, is what java uses to uniquely identify a method;
parameters names in the signature are not used as part of method signature: only types and their order

example

exception list:

method body: a code block containing 0 or more statements

## 2. local and instance variables

instance variables are the data composing the class type (vedi se puoi migliorare e aggiungere qualcosa anche per definire local variables)

local variables are defined within a method or block (all local variable references are destroyed after the block of code enclosing them completes, but the object they point to may still be accessible)
the only modifier which apply to local variable is final!!
explain effectively final local variables!!
effectively final parameters (method and constructor parameters are local variables pre-inizialized: the same rules around final and effectively final apply)
instance variables are those defined as member of a class 

instance variables modifiers: access modifier (see link), final, volatile, transient (table?)

## 3. varargs



