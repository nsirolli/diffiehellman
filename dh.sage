class DiffieHellman():

    def privpub(self):
        a = randint(1,self._p)
        A = self._g^a
        return (a,A)

    def clavepub(self,A,b):
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

    def __init__(self,pdig):
        """
        Protocolo Diffie-Hellman, donde el primo tiene pdig digitos.
        """
        n = 10^(pdig-1)
        self._p = random_prime(10*n,lbound=n)
        self._g = mod(primitive_root(self._p),self._p)
        # global p; global g
        # p = self._p
        # g = self._g

    def __repr__(self):
        return "Protocolo Diffie-Hellman: el primo es %d y la base es %d" \
                %(self._p,self._g)










# #!/usr/bin/python2.7
# import commands
# # from random import randint
# from ast import literal_eval
# # from primefac import primefac
# # from math import exp, sqrt, log

# # Note: This script requires SageMath
# # (run with Python, not Sage)
# # https://www.sagemath.org/

# # parameters:
# # (from Hoffstein Pipher Silverman p.167)
# g = 37
# h = 211
# p = 18443
# B = 5
# max_equations = 6000

# # potencias
# # def pow(x,k,m):
    # # return mod(x^k,m)

# # L complexity notation
# def L(x): return exp(log(x)*sqrt(log(log(x))))

# # determine if n is B-smooth (uses fast factoring)
# def is_Bsmooth(b, n):
    # P = prime_factors(n)
    # # P = list(primefac(n))
    # if len(P) != 0 and P[-1] <= b: 
        # return True, P
    # else: return False, P

# # Euclidean modular inverse
# def euclid_modinv(b, n):
    # x0, x1 = 1, 0
    # while n != 0:
        # q, b, n = b // n, n, b % n
        # x0, x1 = x1, x0 - q * x1
    # return x0

# # convert a list of prime factors (with repetition) to 
# # a dictionary of prime factors and their exponents.
# def factorlist_to_explist(L):
    # D = {}
    # for n in L:
        # try: D[int(n)] += 1
        # except: D[int(n)] = 1
    # return {base : D[base] for base in D.keys()}

# # adapted from https://rosettacode.org/wiki/Chinese_remainder_theorem#Python
# def chinese_remainder(n, a):
    # prod = reduce(lambda a, b: a*b, n)
    # f = lambda a_i, n_i: a_i * euclid_modinv(prod / n_i, n_i) * (prod / n_i) 
    # return sum([f(a_i, n_i) for n_i, a_i in zip(n, a)]) % prod

# # find congruences in accordance with Hoffstein, Phipher, Silverman (3.32)
# def find_congruences(congruences=[], bases=[]):
    # unique = lambda l: list(set(l))
    # while True:                                                    
        # k = randint(2, p)                                                          
        # _ = is_Bsmooth(B,  pow(g,k,p).lift())                                             
        # # _ = is_Bsmooth(B,  pow(g,k,p))                                             
        # if _[0]:                                                                   
            # congruences.append((factorlist_to_explist(_[1]),k))                    
            # bases = unique([base for c in [c[0].keys() for c in congruences] for base in c])
            # if len(congruences) >= max_equations: break
    # print 'congruences: {}\nbases: {}'.format(len(congruences), len(bases))
    # return bases, congruences

# # convert the linear system  to dense matrices 
# def to_matrices(bases, congruences):
    # M = [[c[0][base] if c[0].has_key(base) else 0 \
            # for base in bases] for c in congruences]
    # b = [c[1] for c in congruences]
    # return M, b

# # use sage to solve (potentially) big systems of equations:
# def msolve(M,b):
    # sage_cmd = 'L1 = {};L2 = {};R = IntegerModRing({});M = Matrix(R, L1);\
		    # b = vector(R, L2);print M.solve_right(b)'.format(M,b,p-1)
    # with open('run.sage', 'w') as output_file: output_file.write(sage_cmd)
    # cmd_result = commands.getstatusoutput('sage ./run.sage')
    # if cmd_result[0] != 0: print 'sage failed with error {}'.format(cmd_result[0]); exit()
    # return literal_eval(cmd_result[1])


# # solves a linear equation 
# def evaluate(eq, dlogs):
    # return sum([dlogs[term] * exp for term, exp in eq.iteritems()]) % (p-1)

# def check_congruences(congruences, dlogs):
    # print 'checking congruences:',; passed = True 
    # for c in congruences:
        # if evaluate(c[0], dlogs) != c[1]: passed = False
    # if passed: print 'Passed!\n'
    # else: print 'Failed, try running again?'; exit()
    # return passed

# def check_dlogs(exponents, bases):
    # print 'checking dlog exponents:'; passed = True 
    # for exponent, base in zip(exponents, bases):
        # if pow(g, exponent, p) != base: passed = False
        # else: print '{}^{} = {} (mod {})'.format(g,exponent, base, p)
    # if passed: print 'Passed!\n'
    # else: print 'Failed, try running again.'; exit()
    # return passed

# def main():
    # # generate and solve congruences:
    # print 'p: {}, g: {}, h: {}, B: {}'.format(p,g,h,B)
    # print 'searching for congruences.'
    # bases, congruences = find_congruences()
    # print 'converting to matrix format.'
    # M, b = to_matrices(bases, congruences)
    # print 'solving linear system with sage:'
    # exponents = msolve(M,b)
    # print 'sage done.'

    # # dictionary of bases and exponents
    # dlogs = {b : exp for (b,exp) in zip(bases, exponents)}

    # # verify our results:
    # check_congruences(congruences, dlogs); check_dlogs(exponents, bases)

    # print 'searching for k such that h*g^-k is B-smooth.'
    # for i in xrange(10**9):
        # k = randint(2, p)
        # c = is_Bsmooth(B, (h * pow(euclid_modinv(g,p),k)) % p)
        # if c[0]: print 'found k = {}'.format(k) ; break

    # print 'Solving the main dlog problem:\n'
    # soln = (evaluate(factorlist_to_explist(c[1]), dlogs) + k) % (p-1)
    # if pow(g,soln,p) == h: 
        # print '{}^{} = {} (mod {}) holds!'.format(g,soln,h,p)
        # print 'DLP solution: {}'.format(soln)
    # else: print 'Failed.'

# # if __name__ == '__main__': main()

    


# # def pruebaDH(min,max):
    # # global p; global g; global a; global b; global A; global B
    # # p = random_prime(max,lbound=min)
    # # g = mod(primitive_root(p),p)
    # # a = randint(1,p)
    # # b = randint(1,p)
    # # A = g^a
    # # B = g^b

# # def fuerzabruta(g,m,p):
    # # a = 1
    # # while True:
       # # if mod(g^a,p) == m:
           # # return a
       # # else:
           # # a += 1

# # def bsgs(g,m,p):
   # # n = 1 + floor(sqrt(p-1))
   # # L1 = {}
   # # pot1 = 1; k = 0
   # # while k < n+1:
      # # L1[pot1] = k
      # # pot1 = g*pot1; k += 1
   # # L2 = {}
   # # u = g/pot1
   # # pot2 = m; l = 0
   # # while l < n+1:
      # # L2[pot2] = l
      # # pot2 = u*pot2; l += 1
   # # S1 = set(L1); S2 = set(L2)
   # # S = S1.intersection(S2)
   # # for x in S:
      # # break
   # # i = L1[x]; j = L2[x]
   # # return (i + j*n) % (p-1)

