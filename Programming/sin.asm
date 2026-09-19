.data
degree: .double 750.0
pie: .double 3.14159265359
tpie: .double 6.28318530718
pief: .double 0.78539816339
piet: .double 1.57079632679
.text
.globl main
main:
	la t0,degree 
	fld f0,0(t0) #x
	la t0,pie
	fld f2,0(t0) #pie
	la t0,tpie #2pie
	fld f6,0(t0) #f3 = 2*pie
	la t0,pief #pief
	fld f8,0(t0) #f4 = pie/4
	fneg.d f12,f8 #f6 = -pie/4
	la t0,piet 
	fld f14,0(t0) #f7 = pie/2
	fneg.d f16,f14 #f8 = -pie/2
	###convert to radians##
	li t0,180
	fcvt.d.w f4,t0 #180 in fp
	fdiv.d f4,f2,f4 #f2 = pie by 180
	fmul.d f0,f0,f4 # x=x*pie/180 
	####taking mod a mod b = a-(a/b)*b,b= f3,a=f0###
	fdiv.d f10,f0,f6 #a/b in float
	fcvt.w.d t0,f10 #a/b in int
	fcvt.d.w f10,t0 #a/b in float
	fmul.d f10,f10,f6 #f5 = a/b*b
	fsub.d f0,f0,f10 #f0 = xmod 2pie
	#######if x>pie###################
	flt.d t0, f2, f0    # t0 = 1 if f1 < f0  → f0 > f1
        bnez  t0, range
	j next
	range:fsub.d f0,f0,f6 #x-2pie
	##########x pie/4 conditions##
	next:flt.d t0,f8,f0#x>pie/4
	     bnez  t0, great
	     fle.d t0,f0,f12#x<-pie/4
	     bnez  t0, less
	     j tay
	great:fsub.d f0,f14,f0 #pie/2-x
		j tay
	less: fsub.d f0,f16,f0 #-pie/2-x
	#########maclaurin series sinx=x-x^3/3!######3
	tay:fmul.d f18,f0,f0 #f18=x^2
	    fmul.d f24,f18,f0 #f24= x^3
	    li t0,6
	    fcvt.d.w f20,t0 #6 in double
	    fdiv.d f20,f24,f20 #x^3/6
	    
	    fmul.d f26,f24,f18 #f26 = x^5
	    li t1,120
	    fcvt.d.w f28,t1 #120 in double
	    fdiv.d f26,f26,f28 #x^5/120
	    
	    fsub.d f22,f0,f20 
	    fadd.d f22,f22,f26
	    
	    
	    fmv.d fa0,f22
	    li a7,3
	    ecall
	    
	    li a7,10
	    ecall
	     
	
	
	
	