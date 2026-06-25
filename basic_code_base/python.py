# from pathlib import Path

# # Create a Path object for the current directory
# p = Path.cwd()

# # Find all .py files recursively in this folder and all subfolders
# files = p.rglob('*')

# for f in files:
#     print(f)




# import numpy as np

# # Original array
# original = np.array([1, 2, 3])

# # 1. np.array creates a COPY
# arr_copy = np.array(original)

# # 2. np.asarray creates a VIEW (Reference)
# arr_view = np.asarray(original)

# # Modify the original array
# original[0] = 99

# print(f"Original: {original}")  # [99, 2, 3]
# print(f"np.array: {arr_copy}")  # [ 1, 2, 3] -> (Unchanged, it's a copy)
# print(f"np.asarray: {arr_view}")# [99, 2, 3] -> (Changed, it's a view)



# ravel() → tries no new memory  
# flatten() → always creates copy

# ravel() in NumPy = flatten array into 1D (single row) if possible without copying memory.
# Example:
# a = np.array([
#     [1, 2],
#     [3, 4]
# ])
# Shape:
# (2,2)
# Now:
# a.ravel()
# Output:
# [1 2 3 4]
# Shape:
# (4,)


# def square(n):
#     return n*n
# def cube(n):
#     return n**3          

# def operate(n,op):

#     for nums in n:
#         on=op(nums)            
#         print(f"{op.__name__} of {nums} :",on)              

# operate([3,4],square)   
# operate([2,3],lambda n:n+100)            




# def outer():
#     def inner(x):
#         print(x)
#         inner(91)
#     return inner
    

# fn = outer()
# fn(99)


# def counter_factory(start):
#     count = start

#     def increment():
#         #  count  
#         # count=0
#         nonlocal count
#         count += 1
#         return count

#     return increment

# counter =(counter_factory(10))

# print(counter())   # 11
# print(counter())   # 12
# print(counter())   # 13




# def greaternumfirst(func):
#     def wrap(a,b):
#         if a<b:
#             a,b=b,a
#         return func(a,b)
#     return wrap


# @greaternumfirst
# def sub(a,b):
#     return a-b

# print(sub(2,8))



# class phone:
#     brand="Oneplus"
#     def __init__(self,version,camera,quality):
#       self.version=version
#       self.camera=camera
#       self.quality=quality
#     def config(self):
#        return print(f"Oneplus has of this version:{self.version} having this camera {self.camera} have very {self.quality} quality")
    
# ph=phone("ce3","sony","good")
# ph.config()


# class Phone(B):
#     brand = "Oneplus"
#     def __init__(self, version, camera, quality):
#         self.version = version
#         self.camera = camera
#         self.quality = quality
#     def config(self):   # remove __
#         print(f"Oneplus version: {ph.version}, camera: {self.camera}, quality: {self.quality}")
# ph = Phone("ce3", "sony", "good")
# ph.config()
# Phone.config(ph)

# def greaternumfirst(func):
#     def wrap(func):
#          if a <b:
#            a,b=b,a
#          return func(a,b)
#     return wrap
 

 
# def greaternumfirst(func):
#     def wrap(a,b):
#         if a<b:
#             a,b=a,b
#         return func(a,b)
#     return wrap

# @greaternumfirst
# def subtract(a,b):
#     return a-b

# print(subtract(2,6))