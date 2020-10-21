import numpy as np
from base_test import ArkoudaTest
from context import arkouda as ak
from context import arkouda

'''
Encapsulates test cases for pdarray creation methods
'''
class PdarrayCreationTest(ArkoudaTest):
   
    def testRandint(self):
        test_array = ak.randint(0, 10, 5)
        self.assertEqual(5, len(test_array))
        self.assertEqual(ak.int64, test_array.dtype)
        self.assertEqual([5], test_array.shape)
        
        test_ndarray = test_array.to_ndarray()
        
        for value in test_ndarray:
            self.assertTrue(0 <= value <= 10)
                          
        test_array = ak.randint(0, 1, 3, dtype=ak.float64)
        self.assertEqual(ak.float64, test_array.dtype)
        
        test_array = ak.randint(0, 1, 5, dtype=ak.bool)
        self.assertEqual(ak.bool, test_array.dtype)
        
        test_ndarray = test_array.to_ndarray()
        
        for value in test_ndarray:
            self.assertTrue(value in [True,False])
           
        with self.assertRaises(TypeError):
            ak.randint(low=5)
            
        with self.assertRaises(TypeError):
            ak.randint(high=5)

        with self.assertRaises(TypeError):            
            ak.randint()

        with self.assertRaises(ValueError):
            ak.randint(low=0, high=1, size=-1, dtype=ak.float64)
    
    def testUniform(self):
        test_array = ak.uniform(3)
        self.assertEqual(ak.float64, test_array.dtype)
        self.assertEqual([3], test_array.shape)

        with self.assertRaises(TypeError):
            ak.uniform(low=5)
    
        with self.assertRaises(TypeError):
            ak.randint(high=5)
            
        with self.assertRaises(TypeError):
            ak.randint()
 
    def testZeros(self):
        intZeros = ak.zeros(5, dtype=ak.int64)
        self.assertEqual(ak.int64,intZeros.dtype)
        
        floatZeros = ak.zeros(5, dtype=ak.float64)
        self.assertEqual(ak.float64,floatZeros.dtype)
        
        boolZeros = ak.zeros(5, dtype=ak.bool)
        self.assertEqual(ak.bool,boolZeros.dtype)
        
        zeros  = ak.zeros('5')
        self.assertEqual(5, len(zeros))

        with self.assertRaises(TypeError):
            ak.zeros(5, dtype=ak.uint8)
            
        with self.assertRaises(TypeError):
            ak.zeros(5, dtype=str)        
            
    def testOnes(self):
        intOnes = ak.ones(5, dtype=ak.int64)
        self.assertEqual(ak.int64,intOnes.dtype)
        
        floatOnes = ak.ones(5, dtype=ak.float64)
        self.assertEqual(ak.float64,floatOnes.dtype)
        
        boolOnes = ak.ones(5, dtype=ak.bool)
        self.assertEqual(ak.bool,boolOnes.dtype)

        ones = ak.ones('5')
        self.assertEqual(5, len(ones))
        
        with self.assertRaises(TypeError):
            ak.ones(5, dtype=ak.uint8)
            
        with self.assertRaises(TypeError):
            ak.ones(5, dtype=str)       
    
    def testMulitdimensionalArrayCreation(self):
        with self.assertRaises(RuntimeError) as cm:
            ak.array([[0,0],[0,1],[1,1]])
            
        self.assertEqual('Only rank-1 pdarrays or ndarrays supported', 
                         cm.exception.args[0])