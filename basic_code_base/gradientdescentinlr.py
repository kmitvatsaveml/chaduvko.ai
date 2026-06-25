import math
import random
import numpy as np

def dotprod(a,b):
    result=0.0
    for a,b in zip(a,b):
       result+=a*b
    return result
def sample_top5(inputs, outputs, topk=5):
    """
    Printing the top k
    """
    paired = list(zip(outputs, inputs))
    paired.sort(key=lambda x: x[0], reverse=True)
    print(f"Top {topk} samples by output value:")
    for i, (out, inp) in enumerate(paired[:topk], start=1):
        print(f"{i}. output={out:.4f}, input={inp}")

def sample_bottom5(inputs,outputs,bottomk=5):
    """
    printing the bottom k
    """
    paired =list(zip(outputs,inputs))
    paired.sort(key= lambda x: x[0],reverse=False)
    print(f"Bottom {bottomk} samples by output value:")
    for i,(out,inp) in enumerate(paired[:bottomk],start=1):
        print(f"{i}. output={out:.4f} ,input={inp}")

def hessianchecking(inputs):
    """ 
    hessian checking for convexity of the function
    """
    n_samples=len(inputs)
    n_features=len(inputs[0])
    print(n_samples,"num in hessian input")
    print(n_features,"num of inputs features  hessian ")
    X=np.array(inputs)
    hessian=2/n_samples*X.T@X
    print("hessian of matrice:")
    print(hessian)
    eigenvalues=np.linalg.eigvals(hessian)
    print("eigenvalues are:")
    print(eigenvalues)
    tolerance=1e-8
    if np.all(eigenvalues>tolerance):
         print("It's a convex function")
    else :
         print("its a non convex function!")


def predict_linear(weights,input):
    """ wtranspose x"""
    return  dotprod(weights,input)

def mse(predictions,trueoutputs):
     """
     mse for n samples
     """
     n_samples=len(trueoutputs)
     e=0.0
     for x,y in zip(predictions,trueoutputs):
         e+=(x-y)**2
     return e/n_samples
def calcmsegrad(input,true_outputs,weights):
    """
    returns gradients
    """
    n_input=len(input)
    n_grad=len(weights)
    grad=[0.0]*n_grad
    for input,output in zip(input,true_outputs):
        predicted_output=predict_linear(weights,input)
        e=predicted_output-output
        for wi in range(n_grad):
            grad[wi]+= (2.0/n_input)*(e)*(input[wi])
    return grad

def l1grad(weight,l1):
    """
    returns l1 where w>0,-l1 where w<0
    """
    if weight>0:
        return l1
    elif weight<0:
        return -l1
    else:
        return 0.0

def l2grad(weight,l2):
    """
    returns 2*l2*weight
    """
    return 2.0 *l2*weight


def vectornorm(mse_gradient):
    """
    sqrt (for all sum of vi**2)
    """
    res=sum( vectormse**2 for vectormse in mse_gradient)
    return math.sqrt(res)


def scalarMul(a,vector):
    return [a*vi for vi in vector]

def vectorsubtract(a,b):
    """
     using for weights subtraction
     """
    return [ai-bi for ai,bi in zip(a,b)]

 
def gradient_descent(inputs,true_outputs,lr,iterations,l1=0,l2=0):
    """
    w=w-ndl/dw  l1 l2 
    """
    n_features=len(inputs[0])
    weights=[random.uniform(-0.5,0.5) for i in range(n_features)]
    losshis=[]
    print(weights,"before gd")
    print("gradient descent of:")
    print("lr",lr)
    print("l1:",l1)
    print("l2",l2)
    for iteration in range(iterations):
        predictions=[predict_linear(weights,i) for i in inputs]
        loss= mse(predictions,true_outputs)
        if l1>0:
            loss+=l1*sum(abs(w) for w in weights)
        if l2>0:
            loss+=l2* sum(w**2 for w in weights)
        losshis.append(loss)
        
        mse_gradient=calcmsegrad(inputs,true_outputs,weights)
        for wi in range(n_features):
            if l1>0:
                mse_gradient[wi]+=l1grad(weights[wi],l1)
            if l2>0:
                mse_gradient[wi]+=l2grad(weights[wi],l2)
        gradnorm=vectornorm(mse_gradient)
        if gradnorm< 1e-6:
            print(f"converged at iteration{iteration}")
            break
        gradstep=scalarMul(lr,mse_gradient)
        weights=vectorsubtract(weights,gradstep)

        if iteration%200==0 or iteration<5:
          print(f"Iter   {iteration}| Loss:{loss}  | Grad: {gradnorm}")
    print("final loss:",loss)
    print("final weights:",weights)

    return weights,losshis
    



def main():
    print("hello world!!")
    random.seed(42)

    true_weights=[2.0,1.0,2.0,1.0]
    inputs=[]
    true_outputs=[]
    n_samples=1000
    d=len(true_weights)
    for i in range(n_samples):
        sin= [random.randint(-10,10)  for _ in range(d)]
        sout= dotprod(true_weights,sin)
        inputs.append(sin)
        true_outputs.append(sout)

    print("Generated Nsamples",n_samples)
    print("True weights",true_weights)
    
    sample_top5(inputs,true_outputs,topk=10)
    sample_bottom5(inputs,true_outputs,bottomk=10)
    hessianchecking(inputs)
    

   
    learned_weights,loss_history= gradient_descent(inputs,true_outputs,lr=0.001,iterations=1000)
    learned_weights,loss_history=gradient_descent(inputs,true_outputs,lr=0.001,iterations=1000,l1=0.01)
    learned_weights,loss_history=gradient_descent(inputs,true_outputs,lr=0.001,iterations=1000,l2=0.01)


    learned_weights,loss_history= gradient_descent(inputs,true_outputs,lr=0.01,iterations=1000)
    learned_weights,loss_history=gradient_descent(inputs,true_outputs,lr=0.01,iterations=1000,l1=0.01)
    learned_weights,loss_history=gradient_descent(inputs,true_outputs,lr=0.01,iterations=1000,l2=0.01)




if __name__=="__main__":
    main()