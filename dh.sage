class DiffieHellman():

    def __init__(self,pdig):
        """
        Protocolo Diffie-Hellman, donde el primo tiene pdig digitos.
        """
        n = 10^(pdig-1)
        self._p = random_prime(10*n,lbound=n)
        self._g = mod(primitive_root(self._p),self._p)
        global p; global g
        p = self._p
        g = self._g

    def privpub(self):
        a = randint(1,self._p)
        A = self._g^a
        return (a,A)

    def secreto(self,A,b):
        return A^b

    def fuerzabruta(self,c):
        c = mod(c,self._p)
        h = 1
        for k in xrange(self._p):
           if h == c:
               return k
           else:
               h *= self._g

    def bebegigante(self,c):
        c = mod(c,self._p)
        n = 1 + floor(sqrt(self._p - 1))
        L1 = {}
        pot1 = 1
        for k in xrange(n+1):
            L1[pot1] = k
            pot1 *= self._g
        L2 = {}
        u = self._g/pot1
        pot2 = c
        for l in xrange(n+1):
            L2[pot2] = l
            pot2 *= u
        S1 = set(L1); S2 = set(L2)
        S = S1.intersection(S2)
        for x in S:
            break
        i = L1[x]; j = L2[x]
        return (i + j*n) % (self._p-1)

    def elgamalE(self,m,A):
        m = mod(m,self._p)
        b,B = self.privpub()
        return m*A^b,B

    def elgamalD(self,c,B,a):
        C = B^a
        return 1/C * c

    def p(self):
        return self._p

    def g(self):
        return self._g

    def params(self):
        return self._p,self._g

    def __repr__(self):
        return "Protocolo Diffie-Hellman: el primo es %d y la base es %d" \
