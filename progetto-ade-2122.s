#Progetto Architetture degli Elaboratori 2021/2022 - Jonathan Colombo

.data
    sostK: .word 1
    myPlainText: .string "AMO AssEMBLY"
    characterUnderLine: .byte 10       
    characterDiv: .word 0          	
	 myCypher: .string "A"
	 stringExit: .string "Programma terminato!"
	 stringCypherExit: .string "Caratteri terminati nella chiave!"
    stringDebugA: .string "Debug algoritmo A -> " 
    stringFinal: .string "Stringa computata -> "
    
.text 
    main:
        la a0 myPlainText
        li a7 4
        ecall 
        
        la a0 characterUnderLine
        la a1 11
        ecall
        
        la a0 myCypher
        la a1 myPlainText
        li s1 65	#carico A
        li s2 66 	#carico B
        li s3 67    #carico C
        li s4 68    #carico D
        li s5 69    #carico E
        jal encryptString
        jal decryptString
        j endProgram
        
        encryptString:
            
            controlCharacter:
                lb t0 0(a0) #carico il carattere da controllare
                addi a0 a0 1 #incremento di 1 il count di mycypher
                addi sp sp -4 #alloco memoria
                sw a0 0(sp) 
                
                beq t0 zero endEncryptString
                beq t0 s1 cryptA
                #beq t0 s2 algorithmB
                #beq t0 s3 algorithmC
                #beq t0 s4 algorithmD
                #beq t0 s5 algorithmE
                j controlCharacter
                
                cryptA:
                    lw a0 sostK #carico lo shift 
                    addi sp sp -4 #alloco memoria per un byte
                    sw ra 0(sp) #mi salvo l'indirizzo di ritorno
                    jal substitution
                    
                    lw ra 0(sp)
                    addi sp sp 4 
                    
                    la a0 stringDebugA
                    li a7 4
                    ecall
                    
                    add a0 a1 zero
                    add a2 a1 zero
                    
                    li a7 4
                    ecall
                    
                    la a0 characterUnderLine
                    la a1 11
                    ecall
                    
                    addi a1 a2 0
                    lw a0 0(sp)
                    addi sp sp 4
                    j controlCharacter
                   
                    substitution:
                        li t1 26
                        li t2 65
                        li t3 91
                        li t4 97
                        li t5 123 
                        
                        add t6 a1 zero
                        
                        blt a0 zero correctNegative
                        
                        rem a0 a0 t1
                        
                        j loopEncryptA
                        
                        correctNegative:
                            sub a0 zero a0 
                            rem a0 a0 t1
                            sub a0 t1 a0
                            
                            loopEncryptA:
                                lb t0 0(t6)
                                
                                beq t0 zero endEncryptA
                                blt t0 t2 increaseIndexCharacter
                                bge t0 t5 increaseIndexCharacter 
                                blt t0 t3 characterMaiusc
                                blt t0 t4 increaseIndexCharacter
                                
                                #aggiusto i minuscoli
                                add a2 t0 a0
                                addi a2 a2 -97
                                rem a2 a2 t1
                                add a2 a2 t4
                                sb a2 0(t6)
                                j increaseIndexCharacter 
                                
                                characterMaiusc:
                                    add a2 t0 a0 
                                    addi a2 a2 -65
                                    rem a2 a2 t1
                                    add a2 a2 t2
                                    sb a2 0(t6)
                                    j increaseIndexCharacter
                                    
                                    increaseIndexCharacter:
                                        addi t6 t6 1
                                        j loopEncryptA
                                        
                                        endEncryptA:
                                            li t0 0
                                            li t1 0
                                            li t2 0
                                            li t3 0
                                            li t4 0
                                            li t5 0
                                            li t6 0
                                            li a2 0
                                            lw a0 sostK
                                            jr ra
                                            
                decryptString:
                    addi a0 a0 -1    
                        decryptLoop:
                            addi a0 a0 -1
                            lb t0 0(a0)
                            addi sp sp -4
                            sw a0 0(sp)
                            
                            beq t0 zero endDecryptString
                            beq t0 s1 decryptA
                            #beq t0 s2 decryptB
                            #beq t0 s3 decryptC
                            #beq t0 s4 decryptD
                            #beq t0 s5 decryptE
                            j decryptLoop
                
                decryptA:
                    lw a0 sostK
                    addi sp sp -4
                    sw ra 0(sp)
                    jal decryptSubstitution
                    lw ra 0(sp)
                    addi sp sp 4
                    lw a0 0(sp)
                    addi sp sp 4
                    j decryptLoop
                    
                decryptSubstitution:
                    li t1 -1
                    mul a0 a0 t1
                    addi sp sp -4
                    sw ra 0(sp)
                    jal substitution
                    lw ra 0(sp)
                    addi sp sp 4
                    jr ra                                
                 
                                            
                endEncryptString:
                    addi sp sp 4
                    jr ra 
                    
                endDecryptString:
                    addi sp sp 4
                    jr ra
                    
                endProgram:
                    la a0 stringFinal
                    li a7 4
                    ecall
                    
                    add a0 a1 zero #stampo la stringa finale
                    li a7 4 
                    ecall
                    
                    la a0 characterUnderLine
                    la a1 11
                    ecall
                    
                    la a0 stringExit
                    li a7 4
                    ecall
            
            