package com.arsdigitale.cert_examples;

public class Main {

	static public void main(String[] args) {
		
		Double baseDouble = Double.valueOf("300.56");

		Double wrapDouble = baseDouble.doubleValue();
		System.out.println("baseDouble.doubleValue(): " + wrapDouble);
		
		Byte wrapByte = baseDouble.byteValue();
		System.out.println("baseDouble.byteValue(): " + wrapByte);
		
		Integer wrapInt = baseDouble.intValue();
		System.out.println("baseDouble.intValue(): " + wrapInt);
		
		
	}

}
