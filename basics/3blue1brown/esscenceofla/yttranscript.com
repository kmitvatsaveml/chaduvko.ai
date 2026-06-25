create me a neat latex file lecture file with covering all intutions that he stated mathematically,intutionally,if any anything he said explicitly try out 
please mention things intutively and mathematically ,including the mathematical facts , all properties at the end if didnt stated that 3Blue1Brown assumes but does not explicitly state.
dont be like he said like this like that create a professional document latex file ,so that any body can understand basics to really advanced so that we can think,understand like ml scientist example like neel nanda dont state explicitly in this pdf all this i am just admiring to become real good in the field of mechanistic interpretability.

1st vid:

https://www.youtube.com/watch?v=fNk_zzaMoSs&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=1
how he creates visualisation: C:\Users\sriva\OneDrive\Desktop\praveensir\basics\3blue1brown\esscenceofla\learning photos\3bhowheisvisualising.png
:The fundamental, root-of-it-all building block for linear algebra is the vector. So it's worth making sure that we're all on the same page about what exactly a vector is. You see, broadly speaking, there are three distinct but related ideas about vectors, which I'll call the physics student perspective, the computer science student perspective, and the mathematician's perspective. The physics student perspective is that vectors are arrows pointing in space. What defines a given vector is its length and the direction it's pointing, but as long as those two facts are the same, you can move it all around, and it's still the same vector. Vectors that live in the flat plane are two-dimensional, and those sitting in broader space that you and I live in are three-dimensional. The computer science perspective is that vectors are ordered lists of numbers. For example, let's say you were doing some analytics about house prices, and the only features you cared about were square footage and price. You might model each house with a pair of numbers, the first indicating square footage and the second indicating price. Notice the order matters here. In the lingo, you'd be modeling houses as two-dimensional vectors, where in this context, vector is pretty much just a fancy word for list, and what makes it two-dimensional is the fact that the length of that list is two. The mathematician, on the other hand, seeks to generalize both these views, basically saying that a vector can be anything where there's a sensible notion of adding two vectors and multiplying a vector by a number, operations that I'll talk about later on in this video. The details of this view are rather abstract, and I actually think it's healthy to ignore it until the last video of this series, favoring a more concrete setting in the interim. But the reason I bring it up here is that it hints at the fact that the ideas of vector addition and multiplication by numbers will play an important role throughout linear algebra. But before I talk about those operations, let's just settle in on a specific thought to have in mind when I say the word vector. Given the geometric focus that I'm shooting for here, whenever I introduce a new topic involving vectors, I want you to first think about an arrow, and specifically, think about that arrow inside a coordinate system, like the xy-plane, with its tail sitting at the origin. This is a little bit different from the physics student perspective, where vectors can freely sit anywhere they want in space. In linear algebra, it's almost always the case that your vector will be rooted at the origin. Then, once you understand a new concept in the context of arrows in space, we'll translate it over to the list of numbers point of view, which we can do by considering the coordinates of the vector. Now, while I'm sure that many of you are already familiar with this coordinate system, it's worth walking through explicitly, since this is where all of the important back and forth happens between the two perspectives of linear algebra. Focusing our attention on two dimensions for the moment, you have a horizontal line, called the x-axis, and a vertical line, called the y-axis. The place where they intersect is called the origin, which you should think of as the center of space and the root of all vectors. After choosing an arbitrary length to represent one, you make tick marks on each axis to represent this distance. When I want to convey the idea of 2D space as a whole, which you'll see comes up a lot in these videos, I'll extend these tick marks to make grid lines, but right now, they'll actually get a little bit in the way. The coordinates of a vector is a pair of numbers that basically gives instructions for how to get from the tail of that vector at the origin to its tip. The first number tells you how far to walk along the x-axis, positive numbers indicating rightward motion, negative numbers indicating leftward motion, and the second number tells you how far to walk parallel to the y-axis after that, positive numbers indicating upward motion, and negative numbers indicating downward motion. To distinguish vectors from points, the convention is to write this pair of numbers vertically with square brackets around them. Every pair of numbers gives you one and only one vector, and every vector is associated with one and only one pair of numbers. What about in three dimensions? Well, you add a third axis, called the z-axis, which is perpendicular to both the x and y-axes, and in this case, each vector is associated with ordered triplet of numbers. The first tells you how far to move along the x-axis, the second tells you how far to move parallel to the y-axis, and the third one tells you how far to then move parallel to this new z-axis. Every triplet of numbers gives you one unique vector in space, and every vector in space gives you exactly one triplet of numbers. All right, so back to vector addition and multiplication by numbers. After all, every topic in linear algebra is going to center around these two operations. Luckily, each one's pretty straightforward to define. Let's say we have two vectors, one pointing up and a little to the right, and the other one pointing right and down a bit. To add these two vectors, move the second one so that its tail sits at the tip of the first one. Then, if you draw a new vector from the tail of the first one to where the tip of the second one sits, that new vector is their sum. This definition of addition, by the way, is pretty much the only time in linear algebra where we let vectors stray away from the origin. Now, why is this a reasonable thing to do? Why this definition of addition and not some other one? Well, the way I like to think about it is that each vector represents a certain movement, a step with a certain distance and direction in space. If you take a step along the first vector, then take a step in the direction and distance described by the second vector, the overall effect is just the same as if you moved along the sum of those two vectors to start with. You could think about this as an extension of how we think about adding numbers on a number line. One way that we teach kids to think about this, say with 2 plus 5, is to think of moving two steps to the right followed by another five steps to the right. The overall effect is the same as if you just took seven steps to the right. In fact, let's see how vector addition looks numerically. The first vector here has coordinates 1, 2, and the second one has coordinates 3, negative 1. When you take the vector sum using this tip-to-tail method, you can think of a four-step path from the origin to the tip of the second vector. Walk 1 to the right, then 2 up, then 3 to the right, then 1 down. Reorganizing these steps so that you first do all of the rightward motion, then do all the vertical motion, you can read it as saying first move 1 plus 3 to the right, then move 2 minus 1 up. So the new vector has coordinates 1 plus 3 and 2 plus negative 1. In general, vector addition in this list of numbers conception looks like matching up their terms and adding each one together. The other fundamental vector operation is multiplication by a number. Now this is best understood just by looking at a few examples. If you take the number 2 and multiply it by a given vector, it means you stretch out that vector so that it's two times as long as when you started. If you multiply that vector by, say, one-third, it means you squish it down so that it's one-third the original length. When you multiply it by a negative number, like negative 1.8, then the vector first gets flipped around, then stretched out by that factor of 1.8. This process of stretching or squishing or sometimes reversing the direction of a vector is called scaling, and whenever you catch a number like two or one-third or negative 1.8 acting like this, scaling some vector, you call it a scalar. In fact, throughout linear algebra, one of the main things that numbers do is scale vectors, so it's common to use the word scalar pretty much interchangeably with the word number. Numerically, stretching out a vector by a factor of, say, 2, corresponds with multiplying each of its components by that factor, 2. So in the conception of vectors as lists of numbers, multiplying a given vector by a scalar means multiplying each one of those components by that scalar. You'll see in the following videos what I mean when I say linear algebra topics tend to revolve around these two fundamental operations, vector addition and scalar multiplication. And I'll talk more in the last video about how and why the mathematician thinks only about these operations, independent and abstracted away from however you choose to represent vectors. In truth, it doesn't matter whether you think about vectors as fundamentally being arrows in space, like I'm suggesting you do, that happen to have a nice numerical representation, or fundamentally as lists of numbers that happen to have a nice geometric interpretation. The usefulness of linear algebra has less to do with either one of these views than it does with the ability to translate back and forth between them. It gives the data analyst a nice way to conceptualize many lists of numbers in a visual way, which can seriously clarify patterns in data and give a global view of what certain operations do. And on the flip side, it gives people like physicists and computer graphics programmers a language to describe space and the manipulation of space using numbers that can be crunched and run through a computer. When I do math-y animations, for example, I start by thinking about what's actually going on in space, and then get the computer to represent things numerically, thereby figuring out where to place the pixels on the screen. And doing that usually relies on a lot of linear algebra understanding. So there are your vector basics, and in the next video I'll start getting into some pretty neat concepts surrounding vectors like span, bases, and linear dependence. See you then! you
Translation of axes :the transformation obtained by shifting orgin to a ndifferent point in the plane without changing 
the direction of coordinates axes 
x=x'+h
and 
y=y'+k 
Rotation of axes : The transformation obtained by rotating both the coordinate axes in the plane by the equal angle without changing 
the position of the orgin is called rotation of axes    

x=x'costheta-y'sintheta
y= x'sintheta + y'costheta

    | x'  | y'
|x  |costheta |-sintheta |
|y  |sintheta | costheta |

note: tranlation and rotation of axes
if the origin is shifted to (h,k) and then the axes are rotated through an angle theta then the cordinates of a point p(x,y)are transformed as :
p(x',y')=(xcostheta+ysintheta-h,-xsintheta+ycostheta-k)
p(x,y)=(x'costheta-y'sintheta+h,x'sintheta+y'costheta+k)

2nd vid :
https://www.youtube.com/watch?v=k7RM-ot2NWY&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=2
basics/3blue1brown/esscenceofla/learning photos/span.png
basics/3blue1brown/esscenceofla/learning photos/spaninterpretation.png
In the last video, along with the ideas of vector addition and scalar multiplication, I described vector coordinates, where there's this back and forth between, for example, pairs of numbers and two-dimensional vectors. Now, I imagine the vector coordinates were already familiar to a lot of you, but there's another kind of interesting way to think about these coordinates, which is pretty central to linear algebra. When you have a pair of numbers that's meant to describe a vector, like 3, negative 2, I want you to think about each coordinate as a scalar, meaning, think about how each one stretches or squishes vectors. In the xy coordinate system, there are two very special vectors, the one pointing to the right with length 1, commonly called i-hat, or the unit vector in the x direction, and the one pointing straight up with length 1, commonly called j-hat, or the unit vector in the y direction. Now, think of the x coordinate of our vector as a scalar that scales i-hat, stretching it by a factor of 3, and the y coordinate as a scalar that scales j-hat, flipping it and stretching it by a factor of 2. In this sense, the vector that these coordinates describe is the sum of two scaled vectors. That's a surprisingly important concept, this idea of adding together two scaled vectors. Those two vectors, i-hat and j-hat, have a special name, by the way. Together, they're called the basis of a coordinate system. What this means, basically, is that when you think about coordinates as scalars, the basis vectors are what those scalars actually, you know, scale. There's also a more technical definition, but I'll get to that later. By framing our coordinate system in terms of these two special basis vectors, it raises a pretty interesting and subtle point. We could have chosen different basis vectors and gotten a completely reasonable new coordinate system. For example, take some vector pointing up and to the right, along with some other vector pointing down and to the right in some way. Take a moment to think about all the different vectors that you can get by choosing two scalars, using each one to scale one of the vectors, then adding together what you get. Which two-dimensional vectors can you reach by altering the choices of scalars? The answer is that you can reach every possible two-dimensional vector, and I think it's a good puzzle to contemplate why. A new pair of basis vectors like this still gives us a valid way to go back and forth between pairs of numbers and two-dimensional vectors, but the association is definitely different from the one that you get using the more standard basis of i-hat and j-hat. This is something I'll go into much more detail on later, describing the exact relationship between different coordinate systems, but for right now, I just want you to appreciate the fact that any time we describe vectors numerically, it depends on an implicit choice of what basis vectors we're using. So any time that you're scaling two vectors and adding them like this, it's called a linear combination of those two vectors. Where does this word linear come from? Why does this have anything to do with lines? Well, this isn't the etymology, but one way I like to think about it is that if you fix one of those scalars and let the other one change its value freely, the tip of the resulting vector draws a straight line. Now, if you let both scalars range freely and consider every possible vector that you can get, there are two things that can happen. For most pairs of vectors, you'll be able to reach every possible point in the plane. Every two-dimensional vector is within your grasp. However, in the unlucky case where your two original vectors happen to line up, the tip of the resulting vector is limited to just this single line passing through the origin. Actually, technically there's a third possibility too. Both your vectors could be zero, in which case you'd just be stuck at the origin. Here's some more terminology. The set of all possible vectors that you can reach with a linear combination of a given pair of vectors is called the span of those two vectors. So restating what we just saw in this lingo, the span of most pairs of 2D vectors is all vectors of 2D space, but when they line up, their span is all vectors whose tip sit on a certain line. Remember how I said that linear algebra revolves around vector addition and scalar multiplication? Well, the span of two vectors is basically a way of asking what are all the possible vectors you can reach using only these two fundamental operations, vector addition and scalar multiplication. This is a good time to talk about how people commonly think about vectors as points. It gets really crowded to think about a whole collection of vectors sitting on a line, and more crowded still to think about all two-dimensional vectors all at once, filling up the plane. So when dealing with collections of vectors like this, it's common to represent each one with just a point in space, the point at the tip of that vector where, as usual, I want you thinking about that vector with its tail on the origin. That way, if you want to think about every possible vector whose tip sits on a certain line, just think about the line itself. Likewise, to think about all possible two-dimensional vectors all at once, conceptualize each one as the point where its tip sits. So in effect, what you'll be thinking about is the infinite flat sheet of two-dimensional space itself, leaving the arrows out of it. In general, if you're thinking about a vector on its own, think of it as an arrow. And if you're dealing with a collection of vectors, it's convenient to think of them all as points. So for our span example, the span of most pairs of vectors ends up being the entire infinite sheet of two-dimensional space. But if they line up, their span is just a line. The idea of span gets a lot more interesting if we start thinking about vectors in three-dimensional space. For example, if you take two vectors in 3D space that are not pointing in the same direction, what does it mean to take their span? Well, their span is the collection of all possible linear combinations of those two vectors, meaning all possible vectors you get by scaling each of the two of them in some way and then adding them together. You can kind of imagine turning two different knobs to change the two scalars defining the linear combination, adding the scaled vectors and following the tip of the resulting vector. That tip will trace out some kind of flat sheet cutting through the origin of three-dimensional space. This flat sheet is the span of the two vectors. Or more precisely, the set of all possible vectors whose tips sit on that flat sheet is the span of your two vectors. Isn't that a beautiful mental image? So, what happens if we add a third vector and consider the span of all three of those guys? A linear combination of three vectors is defined pretty much the same way as it is for two. You'll choose three different scalars, scale each of those vectors, and then add them all together. And again, the span of these vectors is the set of all possible linear combinations. Two different things could happen here. If your third vector happens to be sitting on the span of the first two, then the span doesn't change. You're sort of trapped on that same flat sheet. In other words, adding a scaled version of that third vector to the linear combination doesn't really give you access to any new vectors. But if you just randomly choose a third vector, it's almost certainly not sitting on the span of those first two. Then, since it's pointing in a separate direction, it unlocks access to every possible three-dimensional vector. One way I like to think about this is that as you scale that new third vector, it moves around that span sheet of the first two, sweeping it through all of space. Another way to think about it is that you're making full use of the three freely changing scalars that you have at your disposal to access the full three dimensions of space. Now, in the case where the third vector was already sitting on the span of the first two, or the case where two vectors happen to line up, we want some terminology to describe the fact that at least one of these vectors is redundant, not adding anything to our span. Whenever this happens, where you have multiple vectors and you could remove one without reducing the span, the relevant terminology is to say that they are linearly dependent. Another way of phrasing that would be to say that one of the vectors can be expressed as a linear combination of the others, since it's already in the span of the others. On the other hand, if each vector really does add another dimension to the span, they're said to be linearly independent. So with all of that terminology, and hopefully with some good mental images to go with it, let me leave you with a puzzle before we go. The technical definition of a basis of a space is a set of linearly independent vectors that span that space. Now, given how I described a basis earlier, and given your current understanding of the words span and linearly independent, think about why this definition
 would make sense. In the next video, I'll get into matrices in transforming space. See you then!

This is a famous intuition from 3Blue1Brown.

The two statements are actually equivalent.

Definition 1 (symmetric)

Vectors u,v,w are linearly independent if

av+bw+cu=0

has only the trivial solution

a=b=c=0.
Definition 2 (geometric)

u is not in the span of v and w:

u

=av+bw

for every choice of a,b.

In words: no vector can be built from the others.

Why are they the same?

Suppose u can be written as

u=av+bw.

Move everything to one side:

av+bw−u=0.

This is

av+bw+(−1)u=0.

Notice the coefficients are

(a,b,−1).

Since −1

=0, we found a nontrivial solution to

av+bw+cu=0.

Therefore the vectors are linearly dependent.

Now the other direction.

Suppose there exists a nontrivial solution

av+bw+cu=0.

At least one coefficient is nonzero.

If c

=0, divide by c:

u=−
c
a
	​

v−
c
b
	​

w.

So u lies in the span of v and w.

Thus the vectors are dependent.

(If c=0, then either a

=0 or b

=0, and you can similarly solve for v or w.)

The geometric picture

In R
3
, two independent vectors v,w create a plane:

span{v,w}.
If u lies inside that plane, then u can be made from v,w ⇒ dependent.
If u sticks out of that plane, then no combination of v,w reaches it ⇒ independent.

That's why 3Blue1Brown says:

Linear independence means each vector contributes a genuinely new direction; none of them is already contained in the span of the others.

The equation av+bw+cu=0 is the algebraic version, and "outside the span" is the geometric version of exactly the same idea.


3rd vid:
https://www.youtube.com/watch?v=kYB8IZa5AuE&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=3
C:\Users\sriva\OneDrive\Desktop\praveensir\basics\3blue1brown\esscenceofla\learning photos\lineartransformation.png
C:\Users\sriva\OneDrive\Desktop\praveensir\basics\3blue1brown\esscenceofla\learning photos\lineartransformation2.png
Hey everyone! If I had to choose just one topic that makes all of the others in linear algebra start to click, and which too often goes unlearned the first time a student takes linear algebra, it would be this one. The idea of a linear transformation and its relation to matrices. For this video, I'm just going to focus on what these transformations look like in the case of two dimensions, and how they relate to the idea of matrix vector multiplication. In particular, I want to show you a way to think about matrix vector multiplication that doesn't rely on memorization. To start, let's just parse this term, linear transformation. Transformation is essentially a fancy word for function. It's something that takes in inputs and spits out an output for each one. Specifically, in the context of linear algebra, we like to think about transformations that take in some vector and spit out another vector. So why use the word transformation instead of function if they mean the same thing? Well, it's to be suggestive of a certain way to visualize this input-output relation. You see, a great way to understand functions of vectors is to use movement. If a transformation takes some input vector to some output vector, we imagine that input vector moving over to the output vector. Then to understand the transformation as a whole, we might imagine watching every possible input vector move over to its corresponding output vector. It gets really crowded to think about all of the vectors all at once, each one as an arrow. So as I mentioned last video, a nice trick is to conceptualize each vector not as an arrow, but as a single point, the point where its tip sits. That way, to think about a transformation taking every possible input vector to some output vector, we watch every point in space moving to some other point. In the case of transformations in two dimensions, to get a better feel for the whole shape of the transformation, I like to do this with all of the points on an infinite grid. I also sometimes like to keep a copy of the grid in the background, just to help keep track of where everything ends up relative to where it starts. The effect for various transformations moving around all of the points in space is, you've got to admit, beautiful. It gives the feeling of squishing and morphing space itself. As you can imagine though, arbitrary transformations can look pretty complicated. But luckily, linear algebra limits itself to a special type of transformation, ones that are easier to understand, called linear transformations. Visually speaking, a transformation is linear if it has two properties. All lines must remain lines without getting curved, and the origin must remain fixed in place. For example, this right here would not be a linear transformation, since the lines get all curvy. And this one right here, although it keeps the lines straight, is not a linear transformation, because it moves the origin. This one here fixes the origin, and it might look like it keeps lines straight, but that's just because I'm only showing the horizontal and vertical grid lines. When you see what it does to a diagonal line, it becomes clear that it's not at all linear, since it turns that line all curvy. In general, you should think of linear transformations as keeping grid lines parallel and evenly spaced. Some linear transformations are simple to think about, like rotations about the origin. Others are a little trickier to describe with words. So, how do you think you could describe these transformations numerically? If you were, say, programming some animations to make a video teaching the topic, what formula do you give the computer so that if you give it the coordinates of a vector, it can give you the coordinates of where that vector lands? It turns out that you only need to record where the two basis vectors, i-hat and j-hat, each land, and everything else will follow from that. For example, consider the vector v with coordinates negative 1, 2, meaning that it equals negative 1 times i-hat plus 2 times j-hat. If we play some transformation and follow where all three of these vectors go, the property that grid lines remain parallel and evenly spaced has a really important consequence. The place where v lands will be negative 1 times the vector where i-hat landed plus 2 times the vector where j-hat landed. In other words, it started off as a certain linear combination of i-hat and j-hat, and it ends up as that same linear combination of where those two vectors landed. This means you can deduce where v must go based only on where i-hat and j-hat each land. This is why I like keeping a copy of the original grid in the background. For the transformation shown here, we can read off that i-hat lands on the coordinates 1, negative 2, and j-hat lands on the x-axis over at the coordinates 3, 0. This means that the vector represented by negative 1 i-hat plus 2 times j-hat ends up at negative 1 times the vector 1, negative 2 plus 2 times the vector 3, 0. Adding that all together, you can deduce that it has to land on the vector 5, 2. This is a good point to pause and ponder, because it's pretty important. Now, given that I'm actually showing you the full transformation, you could have just looked to see that v has the coordinates 5, 2. But the cool part here is that this gives us a technique to deduce where any vectors land so long as we have a record of where i-hat and j-hat each land without needing to watch the transformation itself. Write the vector with more general coordinates, x and y, and it will land on x times the vector where i-hat lands, 1, negative 2, plus y times the vector where j-hat lands, 3, 0. Carrying out that sum, you see that it lands at 1x plus 3y, negative 2x plus 0y. I give you any vector, and you can tell me where that vector lands using this formula. What all of this is saying is that a two-dimensional linear transformation is completely described by just four numbers, the two coordinates for where i-hat lands and the two coordinates for where j-hat lands. Isn't that cool? It's common to package these coordinates into a 2x2 grid of numbers called a 2x2 matrix, where you can interpret the columns as the two special vectors where i-hat and j-hat each land. If you're given a 2x2 matrix describing a linear transformation and some specific vector, and you want to know where that linear transformation takes that vector, you can take the coordinates of the vector, multiply them by the corresponding columns of the matrix, then add together what you get. This corresponds with the idea of adding the scaled versions of our new basis vectors. Let's see what this looks like in the most general case, where your matrix has entries A, B, C, D. And remember, this matrix is just a way of packaging the information needed to describe a linear transformation. Always remember to interpret that first column, AC, as the place where the first basis vector lands, and that second column, BD, as the place where the second basis vector lands. When we apply this transformation to some vector xy, what do you get? Well, it'll be x times AC plus y times BD. Putting this together, you get a vector Ax plus By, Cx plus Dy. You could even define this as matrix vector multiplication, when you put the matrix on the left of the vector like it's a function. Then, you could make high schoolers memorize this without showing them the crucial part that makes it feel intuitive. But, isn't it more fun to think about these columns as the transformed versions of your basis vectors, and to think about the result as the appropriate linear combination of those vectors? Let's practice describing a few linear transformations with matrices. For example, if we rotate all of space 90 degrees counterclockwise, then i-hat lands on the coordinates 0, 1. And j-hat lands on the coordinates negative 1, 0. So the matrix we end up with has columns 0, 1, negative 1, 0. To figure out what happens to any vector after a 90-degree rotation, you could just multiply its coordinates by this matrix. Here's a fun transformation with a special name, called a shear. In it, i-hat remains fixed, so the first column of the matrix is 1, 0. But j-hat moves over to the coordinates 1, 1, which become the second column of the matrix. And at the risk of being redundant here, figuring out how a shear transforms a given vector comes down to multiplying this matrix by that vector. Let's say we want to go the other way around, starting with a matrix, say with columns 1, 2 and 3, 1, and we want to deduce what its transformation looks like. Pause and take a moment to see if you can imagine it. One way to do this is to first move i-hat to 1, 2, then move j-hat to 3, 1. Always moving the rest of space in such a way that keeps gridlines parallel and evenly spaced. If the vectors that i-hat and j-hat land on are linearly dependent, which, if you recall from last video, means that one is a scaled version of the other, it means that the linear transformation squishes all of 2D space onto the line where those two vectors sit, also known as the one-dimensional span of those two linearly dependent vectors. To sum up, linear transformations are a way to move around space such that gridlines remain parallel and evenly spaced, and such that the origin remains fixed. Delightfully, these transformations can be described using only a handful of numbers, the coordinates of where each basis vector lands. Matrices give us a language to describe these transformations, where the columns represent those coordinates, and matrix-vector multiplication is just a way to compute what that transformation does to a given vector. The important takeaway here is that every time you see a matrix, you can interpret it as a certain transformation of space. Once you really digest this idea, you're in a great position to understand linear algebra deeply. Almost all of the topics coming up, from matrix multiplication to determinants, change of basis, eigenvalues, all of these will become easier to understand once you start thinking about matrices as transformations of space. Most immediately, in the next video, I'll be talking about multiplying two matrices together. See you then! Thank you for watching!

4th vid :
https://www.youtube.com/watch?v=XkY2DOUCWMU&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=4
Hey everyone, where we last left off, I showed what linear transformations look like and how to represent them using matrices. This is worth a quick recap because it's just really important, but of course if this feels like more than just a recap, go back and watch the full video. Technically speaking, linear transformations are functions with vectors as inputs and vectors as outputs, but I showed last time how we can think about them visually as smooshing around space in such a way that grid lines stay parallel and evenly spaced, and so that the origin remains fixed. The key takeaway was that a linear transformation is completely determined by where it takes the basis vectors of the space, which for two dimensions means i-hat and j-hat. This is because any other vector could be described as a linear combination of those basis vectors. A vector with coordinates x, y is x times i-hat plus y times j-hat. After going through the transformation, this property that grid lines remain parallel and evenly spaced has a wonderful consequence. The place where your vector lands will be x times the transformed version of i-hat plus y times the transformed version of j-hat. This means if you keep a record of the coordinates where i-hat lands and the coordinates where j-hat lands, you can compute that a vector which starts at x, y must land on x times the new coordinates of i-hat plus y times the new coordinates of j-hat. The convention is to record the coordinates of where i-hat and j-hat land as the columns of a matrix, and to define this sum of the scaled versions of those columns by x and y to be matrix-vector multiplication. In this way, a matrix represents a specific linear transformation, and multiplying a matrix by a vector is what it means computationally to apply that transformation to that vector. Alright, recap over, on to the new stuff. Oftentimes, you find yourself wanting to describe the effects of applying one transformation and then another. For example, maybe you want to describe what happens when you first rotate the plane 90 degrees counterclockwise, then apply a shear. The overall effect here, from start to finish, is another linear transformation, distinct from the rotation and the shear. This new linear transformation is commonly called the composition of the two separate transformations we applied. And like any linear transformation, it can be described with a matrix all of its own by following i-hat and j-hat. In this example, the ultimate landing spot for i-hat after both transformations is 1,1, so let's make that the first column of a matrix. Likewise, j-hat ultimately ends up at the location negative 1,0, so we make that the second column of the matrix. This new matrix captures the overall effect of applying a rotation then a shear, but as one single action, rather than two successive ones. Here's one way to think about that new matrix. If you were to take some vector and pump it through the rotation, then the shear, the long way to compute where it ends up is to first multiply it on the left by the rotation matrix, then take whatever you get and multiply that on the left by the shear matrix. This is, numerically speaking, what it means to apply a rotation then a shear to a given vector. But whatever you get should be the same as just applying this new composition matrix that we just found by that same vector, no matter what vector you chose, since this new matrix is supposed to capture the same overall effect as the rotation then shear action. Based on how things are written down here, I think it's reasonable to call this new matrix the product of the original two matrices, don't you? We can think about how to compute that product more generally in just a moment, but it's way too easy to get lost in the forest of numbers. Always remember that multiplying two matrices like this has the geometric meaning of applying one transformation then another. One thing that's kind of weird here is that this has us reading from right to left. You first apply the transformation represented by the matrix on the right, then you apply the transformation represented by the matrix on the left. This stems from function notation, since we write functions on the left of variables, so every time you compose two functions, you always have to read it right to left. Good news for the Hebrew readers, bad news for the rest of us. Let's look at another example. Take the matrix with columns 1,1 and negative 2,0, whose transformation looks like this. And let's call it M1. Next, take the matrix with columns 0,1 and 2,0, whose transformation looks like this. And let's call that guy M2. The total effect of applying M1 then M2 gives us a new transformation, so let's find its matrix. But this time, let's see if we can do it without watching the animations, and instead just using the numerical entries in each matrix. First, we need to figure out where i-hat goes. After applying M1, the new coordinates of i-hat, by definition, are given by that first column of M1, namely 1,1. To see what happens after applying M2, multiply the matrix for M2 by that vector 1,1. Working it out, the way I described last video, you'll get the vector 2,1. This will be the first column of the composition matrix. Likewise, to follow j-hat, the second column of M1 tells us that it first lands on negative 2,0. Then, when we apply M2 to that vector, you can work out the matrix-vector product to get 0, negative 2, which becomes the second column of our composition matrix. Let me talk through that same process again, but this time I'll show variable entries in each matrix, just to show that the same line of reasoning works for any matrices. This is more symbol-heavy and will require some more room, but it should be pretty satisfying for anyone who has previously been taught matrix multiplication the more rote way. To follow where i-hat goes, start by looking at the first column of the matrix on the right, since this is where i-hat initially lands. Multiplying that column by the matrix on the left is how you can tell where the intermediate version of i-hat ends up after applying the second transformation. So the first column of the composition matrix will always equal the left matrix times the first column of the right matrix. Likewise, j-hat will always initially land on the second column of the right matrix. So multiplying the left matrix by this second column will give its final location, and hence that's the second column of the composition matrix. Notice there's a lot of symbols here, and it's common to be taught this formula as something to memorize, along with a certain algorithmic process to help remember it. But I really do think that before memorizing that process, you should get in the habit of thinking about what matrix multiplication really represents, applying one transformation after another. Trust me, this will give you a much better conceptual framework that makes the properties of matrix multiplication much easier to understand. For example, here's a question. Does it matter what order we put the two matrices in when we multiply them? Well, let's think through a simple example, like the one from earlier. Take a shear, which fixes i-hat and smooshes j-hat over to the right, and a 90 degree rotation. If you first do the shear, then rotate, we can see that i-hat ends up at 0,1 and j-hat ends up at negative 1,1. Both are generally pointing close together. If you first rotate, then do the shear, i-hat ends up over at 1,1, and j-hat is off in a different direction at negative 1,0, and they're pointing, you know, farther apart. The overall effect here is clearly different, so evidently, order totally does matter. Notice, by thinking in terms of transformations, that's the kind of thing that you can do in your head by visualizing. No matrix multiplication necessary. I remember when I first took linear algebra, there was this one homework problem that asked us to prove that matrix multiplication is associative. This means that if you have three matrices, A, B, and C, and you multiply them all together, it shouldn't matter if you first compute A times B, then multiply the result by C, or if you first multiply B times C, then multiply that result by A on the left. In other words, it doesn't matter where you put the parentheses. Now, if you try to work through this numerically, like I did back then, it's horrible, just horrible, and unenlightening for that matter. But when you think about matrix multiplication as applying one transformation after another, this property is just trivial. Can you see why? What it's saying is that if you first apply C, then B, then A, it's the same as applying C, then B, then A. I mean, there's nothing to prove. You're just applying the same three things one after the other, all in the same order. This might feel like cheating, but it's not. This is an honest-to-goodness proof that matrix multiplication is associative, and even better than that, it's a good explanation for why that property should be true. I really do encourage you to play around more with this idea, imagining two different transformations, thinking about what happens when you apply one after the other, and then working out the matrix product numerically. Trust me, this is the kind of playtime that really makes the idea sink in. In the next video, I'll start talking about extending these ideas beyond just two dimensions. See you then!



5th vid:
C:\Users\sriva\OneDrive\Desktop\praveensir\basics\3blue1brown\esscenceofla\learning photos\3dvectoansformation.png
Hey folks, I've got a relatively quick video for you today, just sort of a footnote between chapters. In the last two videos I talked about linear transformations and matrices, but I only showed the specific case of transformations that take two-dimensional vectors to other two-dimensional vectors. In general throughout the series we'll work mainly in two dimensions, mostly because it's easier to actually see on the screen and wrap your mind around. But more importantly than that, once you get all the core ideas in two dimensions, they carry over pretty seamlessly to higher dimensions. Nevertheless, it's good to peek our heads outside of flatland now and then to, you know, see what it means to apply these ideas in more than just those two dimensions. For example, consider a linear transformation with three-dimensional vectors as inputs and three-dimensional vectors as outputs. We can visualize this by smooshing around all the points in three-dimensional space, as represented by a grid, in such a way that keeps the grid lines parallel and evenly spaced, and which fixes the origin in place. And just as with two dimensions, every point of space that we see moving around is really just a proxy for a vector who has its tip at that point, and what we're really doing is thinking about input vectors moving over to their corresponding outputs. And just as with two dimensions, one of these transformations is completely described by where the basis vectors go. But now, there are three standard basis vectors that we typically use. The unit vector in the x direction, i-hat, the unit vector in the y direction, j-hat, and a new guy, the unit vector in the z direction, called k-hat. In fact, I think it's easier to think about these transformations by only following those basis vectors, since the full 3D grid representing all points can get kind of messy. By leaving a copy of the original axes in the background, we can think about the coordinates of where each of these three basis vectors lands. Record the coordinates of these three vectors as the columns of a 3x3 matrix. This gives a matrix that completely describes the transformation using only nine numbers. As a simple example, consider the transformation that rotates space 90 degrees around the y-axis. So that would mean that it takes i-hat to the coordinates 0,0, negative 1 on the z-axis. It doesn't move j-hat, so it stays at the coordinates 0,1,0. And then k-hat moves over to the x-axis at 1,0,0. Those three sets of coordinates become the columns of a matrix that describes that rotation transformation. To see where a vector with coordinates x,y,z lands, the reasoning is almost identical to what it was for two dimensions. Each of those coordinates can be thought of as instructions for how to scale each basis vector so that they add together to get your vector. And the important part, just like the 2D case, is that this scaling and adding process works both before and after the transformation. So to see where your vector lands, you multiply those coordinates by the corresponding columns of the matrix, and then you add together the three results. Multiplying two matrices is also similar. Whenever you see two 3x3 matrices getting multiplied together, you should imagine first applying the transformation encoded by the right one, then applying the transformation encoded by the left one. It turns out that 3D matrix multiplication is actually pretty important for fields like computer graphics and robotics, since things like rotations and three dimensions can be pretty hard to describe, but they're easier to wrap your mind around if you can break them down as the composition of separate, easier-to-think-about rotations. Performing this matrix multiplication numerically is, once again, pretty similar to the two-dimensional case. In fact, a good way to test your understanding of the last video would be to try to reason through what specifically this matrix multiplication should look like, thinking closely about how it relates to the idea of applying two successive transformations in space. In the next video, I'll start getting into the determinant.


6th vid:
https://www.youtube.com/watch?v=Ip3X9LOh2dk&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=6
Hello, hello again. So moving forward, I'll be assuming that you have a visual understanding of linear transformations and how they're represented with matrices, the way that I've been talking about in the last few videos. If you think about a couple of these linear transformations, you might notice how some of them seem to stretch space out, while others squish it on in. One thing that turns out to be pretty useful for understanding one of these transformations is to measure exactly how much it stretches or squishes things. More specifically, to measure the factor by which the area of a given region increases or decreases. For example, look at the matrix with columns 3, 0 and 0, 2. It scales i-hat by a factor of 3 and scales j-hat by a factor of 2. Now, if we focus our attention on the 1 by 1 square whose bottom sits on i-hat and whose left side sits on j-hat, after the transformation, this turns into a 2 by 3 rectangle. Since this region started out with area 1 and ended up with area 6, we can say the linear transformation has scaled its area by a factor of 6. Compare that to a shear, whose matrix has columns 1, 0 and 1, 1, meaning i-hat stays in place and j-hat moves over to 1, 1. That same unit square determined by i-hat and j-hat gets slanted and turned into a parallelogram, but the area of that parallelogram is still 1, since its base and height each continue to have length 1. So even though this transformation smushes things about, it seems to leave areas unchanged, at least in the case of that 1 unit square. Actually though, if you know how much the area of that one single unit square changes, it can tell you how the area of any possible region in space changes. For starters, notice that whatever happens to one square in the grid has to happen to any other square in the grid, no matter the size. This follows from the fact that grid lines remain parallel and evenly spaced. Then, any shape that's not a grid square can be approximated by grid squares pretty well, with arbitrarily good approximations if you use small enough grid squares. So, since the areas of all those tiny grid squares are being scaled by some single amount, the area of the blob as a whole will also be scaled by that same single amount. This very special scaling factor, the factor by which a linear transformation changes any area, is called the determinant of that transformation. I'll show how to compute the determinant of a transformation using its matrix later on in this video, but understanding what it represents is, trust me, much more important than the computation. For example, the determinant of a transformation would be 3 if that transformation increases the area of a region by a factor of 3. 40 00:02:57,610 --&gt; 00:02:57,040 The determinant of a transformation would be ½ 41 00:02:58,180 --&gt; 00:02:57,610 if it squishes down all areas by a factor of ½. The determinant of a transformation would be 1 half if it squishes down all areas by a factor of 1 half. And the determinant of a 2D transformation is 0 if it squishes all of space onto a line, or even onto a single point. Since then, the area of any region would become zero. That last example will prove to be pretty important. It means that checking if the determinant of a given matrix is zero will give a way of computing whether or not the transformation associated with that matrix squishes everything into a smaller dimension. You'll see in the next few videos why this is even a useful thing to think about, but for now, I just want to lay down all of the visual intuition, which, in and of itself, is a beautiful thing to think about. Okay, I need to confess that what I've said so far is not quite right. The full concept of the determinant allows for negative values. But what would the idea of scaling an area by a negative amount even mean? This has to do with the idea of orientation. For example, notice how this transformation gives the sensation of flipping space over. If you were thinking of 2D space as a sheet of paper, a transformation like that one seems to turn over that sheet onto the other side. Any transformations that do this are said to invert the orientation of space. Another way to think about it is in terms of i-hat and j-hat. Notice that in their starting positions, j-hat is to the left of i-hat. If, after a transformation, j-hat is now on the right of i-hat, the orientation of space has been inverted. Whenever this happens, whenever the orientation of space is inverted, the determinant will be negative. The absolute value of the determinant, though, still tells you the factor by which areas have been scaled. For example, the matrix with columns 1, 1 and 2, negative 1 encodes a transformation that has determinant, I'll just tell you, negative 3. And what this means is that space gets flipped over and areas are scaled by a factor of 3. So why would this idea of a negative area scaling factor be a natural way to describe orientation flipping? Think about the series of transformations you get by slowly letting i-hat get closer and closer to j-hat. As i-hat gets closer, all of the areas in space are getting squished more and more, meaning the determinant approaches 0. Once i-hat lines up perfectly with j-hat, the determinant is 0. Then, if i-hat continues the way that it was going, doesn't it kind of feel natural for the determinant to keep decreasing into the negative numbers? So that's the understanding of determinants in two dimensions. What do you think it should mean for three dimensions? It also tells you how much a transformation scales things, but this time, it tells you how much volumes get scaled. Just as in two dimensions, where this is easiest to think about by focusing on one particular square with an area 1 and watching only what happens to it, in three dimensions, it helps to focus your attention on the specific 1 by 1 by 1 cube whose edges are resting on the basis vectors, i-hat, j-hat and k-hat. After the transformation, that cube might get warped into some kind of slanty slanty cube. This shape, by the way, has the best name ever, parallelipiped, a name that's made even more delightful when your professor has a nice thick Russian accent. Since this cube starts out with a volume of 1, and the determinant gives the factor by which any volume is scaled, you can think of the determinant simply as being the volume of that parallelipiped that the cube turns into. A determinant of 0 would mean that all of space is squished onto something with 0 volume, meaning either a flat plane, a line, or, in the most extreme case, onto a single point. Those of you who watched chapter 2 will recognize this as meaning that the columns of the matrix are linearly dependent. Can you see why? What about negative determinants? What should that mean for three dimensions? One way to describe orientation in 3D is with the right hand rule. Point the forefinger of your right hand in the direction of i-hat, stick out your middle finger in the direction of j-hat, and notice how when you point your thumb up, it's in the direction of k-hat. If you can still do that after the transformation, orientation has not changed, and the determinant is positive. Otherwise, if after the transformation it only makes sense to do that with your left hand, orientation has been flipped, and the determinant is negative. So, if you haven't seen it before, you're probably wondering by now, how do you actually compute the determinant? For a 2x2 matrix with entries a, b, c, d, the formula is a times d minus b times c. Here's part of an intuition for where this formula comes from. Let's say that the terms b and c both happened to be 0. Then, the term a tells you how much i-hat is stretched in the x direction, and the term d tells you how much j-hat is stretched in the y direction. So, since those other terms are 0, it should make sense that a times d gives the area of the rectangle that our favorite unit square turns into, kind of like the 3, 0, 0, 2 example from earlier. Even if only one of b or c are 0, you'll have a parallelogram with a base a and a height d. So, the area should still be a times d. Loosely speaking, if both b and c are non-zero, then that b times c term tells you how much this parallelogram is stretched or squished in the diagonal direction. For those of you hungry for a more precise description of this b times c term, here's a helpful diagram if you'd like to pause and ponder. Now, if you feel like computing determinants by hand is something that you need to know, the only way to get it down is to just practice it with a few. There's really not that much I can say or animate that's going to drill in the computation. This is all triply true for three-dimensional determinants. There is a formula, and if you feel like that's something you need to know, you should practice with a few matrices, or, you know, go watch Sal Khan work through a few. Honestly, though, I don't think that those computations fall within the essence of linear algebra, but I definitely think that understanding what the determinant represents falls within that essence. Here's kind of a fun question to think about before the next video. If you multiply two matrices together, the determinant of the resulting matrix is the same as the product of the determinants of the original two matrices. If you tried to justify this with numbers, it would take a really long time, but see if you can explain why this makes sense in just one sentence. Next up, I'll be relating the idea of linear transformations covered so far to one of the areas where linear algebra is most useful, linear systems of equations. See you then!

7th vid:
https://www.youtube.com/watch?v=uQhTuRlWMxw&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=7
As you can probably tell by now, the bulk of this series is on understanding matrix and vector operations through that more visual lens of linear transformations. This video is no exception, describing the concepts of inverse matrices, column space, rank, and null space through that lens. A forewarning though, I'm not going to talk about the methods for actually computing these things, and some would argue that that's pretty important. There are a lot of very good resources for learning those methods outside this series, keywords Gaussian elimination and row echelon form. I think most of the value that I actually have to add here is on the intuition half. Plus, in practice, we usually get software to compute this stuff for us anyway. First, a few words on the usefulness of linear algebra. By now, you already have a hint for how it's used in describing the manipulation of space, which is useful for things like computer graphics and robotics. But one of the main reasons that linear algebra is more broadly applicable and required for just about any technical discipline is that it lets us solve certain systems of equations. When I say system of equations, I mean you have a list of variables, things you don't know, and a list of equations relating them. In a lot of situations, those equations can get very complicated. But, if you're lucky, they might take on a certain special form. Within each equation, the only thing happening to each variable is that it's scaled by some constant, and the only thing happening to each of those scaled variables is that they're added to each other. So no exponents or fancy functions or multiplying two variables together, things like that. The typical way to organize this sort of special system of equations is to throw all the variables on the left and put any lingering constants on the right. It's also nice to vertically line up the common variables, and to do that, you might need to throw in some zero coefficients whenever the variable doesn't show up in one of the equations. This is called a linear system of equations. You might notice that this looks a lot like matrix-vector multiplication. In fact, you can package all of the equations together into a single vector equation where you have the matrix containing all of the constant coefficients and a vector containing all of the variables, and their matrix-vector product equals some different constant vector. Let's name that constant matrix A, denote the vector holding the variables with a bold-faced X, and call the constant vector on the right-hand side V. This is more than just a notational trick to get our system of equations written on one line. It sheds light on a pretty cool geometric interpretation for the problem. The matrix A corresponds with some linear transformation, so solving Ax equals V means we're looking for a vector X, which, after applying the transformation, lands on V. Think about what's happening here for a moment. You can hold in your head this really complicated idea of multiple variables all intermingling with each other just by thinking about squishing and morphing space and trying to figure out which vector lands on another. Cool, right? To start simple, let's say you have a system with two equations and two unknowns. This means the matrix A is a 2x2 matrix, and V and X are each two-dimensional vectors. Now, how we think about the solutions to this equation depends on whether the transformation associated with A squishes all of space into a lower dimension, like a line or a point, or if it leaves everything spanning the full two dimensions where it started. In the language of the last video, we subdivide into the cases where A has zero determinant and the case where A has non-zero determinant. Let's start with the most likely case, where the determinant is non-zero, meaning space does not get squished into a zero-area region. In this case, there will always be one and only one vector that lands on V, and you can find it by playing the transformation in reverse. Following where V goes as we rewind the tape like this, you'll find the vector x such that A times x equals V. When you play the transformation in reverse, it actually corresponds to a separate linear transformation, commonly called the inverse of A, denoted A to the negative one. For example, if A was a counterclockwise rotation by 90 degrees, then the inverse of A would be a clockwise rotation by 90 degrees. If A was a rightward shear that pushes j-hat one unit to the right, the inverse of A would be a leftward shear that pushes j-hat one unit to the left. In general, A inverse is the unique transformation with the property that if you first apply A, then follow it with the transformation A inverse, you end up back where you started. Applying one transformation after another is captured algebraically with matrix multiplication, so the core property of this transformation A inverse is that A inverse times A equals the matrix that corresponds to doing nothing. The transformation that does nothing is called the identity transformation. It leaves i-hat and j-hat each where they are, unmoved, so its columns are 1,0 and 0,1. Once you find this inverse, which in practice you'd do with a computer, you can solve your equation by multiplying this inverse matrix by v. And again, what this means geometrically is that you're playing the transformation in reverse and following v. This non-zero determinant case, which for a random choice of matrix is by far the most likely one, corresponds with the idea that if you have two unknowns and two equations, it's almost certainly the case that there's a single unique solution. This idea also makes sense in higher dimensions, when the number of equations equals the number of unknowns. Again, the system of equations can be translated to the geometric interpretation where you have some transformation A and some vector v, and you're looking for the vector x that lands on v. As long as the transformation A doesn't squish all of space into a lower dimension, meaning its determinant is non-zero, there will be an inverse transformation A inverse, with the property that if you first do A, then you do A inverse, it's the same as doing nothing. And to solve your equation, you just have to multiply that reverse transformation matrix by the vector v. But when the determinant is zero, and the transformation associated with the system of equations squishes space into a smaller dimension, there is no inverse. You cannot unsquish a line to turn it into a plane. At least that's not something that a function can do. That would require transforming each individual vector into a whole line full of vectors. But functions can only take a single input to a single output. Similarly, for three equations and three unknowns, there will be no inverse if the corresponding transformation squishes 3D space onto the plane, or even if it squishes it onto a line or a point. Those all correspond to a determinant of zero, since any region is squished into something with zero volume. It's still possible that a solution exists even when there is no inverse. It's just that when your transformation squishes space onto, say, a line, you have to be lucky enough that the vector v lives somewhere on that line. You might notice that some of these zero determinant cases feel a lot more restrictive than others. Given a 3x3 matrix, for example, it seems a lot harder for a solution to exist when it squishes space onto a line compared to when it squishes things onto a plane, even though both of those are zero determinant. We have some language that's a bit more specific than just saying zero determinant. When the output of a transformation is a line, meaning it's one-dimensional, we say the transformation has a rank of one. If all the vectors land on some two-dimensional plane, we say the transformation has a rank of two. So the word rank means the number of dimensions in the output of a transformation. For instance, in the case of 2x2 matrices, rank two is the best that it can be. It means the basis vectors continue to span the full two dimensions of space, and the determinant is not zero. But for 3x3 matrices, rank two means that we've collapsed, but not as much as they would have collapsed for a rank one situation. If a 3D transformation has a non-zero determinant and its output fills all of 3D space, it has a rank of three. This set of all possible outputs for your matrix, whether it's a line, a plane, 3D space, whatever, is called the column space of your matrix. You can probably guess where that name comes from. The columns of your matrix tell you where the basis vectors land, and the span of those transformed basis vectors gives you all possible outputs. In other words, the column space is the span of the columns of your matrix. So a more precise definition of rank would be that it's the number of dimensions in the column space. When this rank is as high as it can be, meaning it equals the number of columns, we call the matrix full rank. Notice the zero vector will always be included in the column space, since linear transformations must keep the origin fixed in place. For a full rank transformation, the only vector that lands at the origin is the zero vector itself. But for matrices that aren't full rank, which squish to a smaller dimension, you can have a whole bunch of vectors that land on zero. If a 2D transformation squishes space onto a line, for example, there is a separate line in a different direction full of vectors that get squished onto the origin. If a 3D transformation squishes space onto a plane, there's also a full line of vectors that land on the origin. If a 3D transformation squishes all of space onto a line, then there's a whole plane full of vectors that land on the origin. This set of vectors that lands on the origin is called the null space, or the kernel of your matrix. It's the space of all vectors that become null, in the sense that they land on the zero vector. In terms of the linear system of equations, when v happens to be the zero vector, the null space gives you all of the possible solutions to the equation. So that's a very high level overview of how to think about linear systems of equations geometrically. Each system has some kind of linear transformation associated with it, and when that transformation has an inverse, you can use that inverse to solve your system. Otherwise, the idea of column space lets us understand when a solution even exists, and the idea of a null space helps us to understand what the set of all possible solutions can look like. Again, there's a lot that I haven't covered here, most notably how to compute these things. I also had to limit my scope to examples where the number of equations equals the number of unknowns. But the goal here is not to try to teach everything, it's that you come away with a strong intuition for inverse matrices, column space, and null space, and that those intuitions make any future learning that you do more fruitful. Next video, by popular request, will be a brief footnote about non-square matrices. Then after that, I'm going to give you my take on dot products, and something pretty cool that happens when you view them under the light of linear transformations. See you then!
-->https://www.youtube.com/watch?v=VwrSPtC6TcI:Suppose we take a matrix with the first row as 2 and 0 and second row as 0 and three. Now multiply this with a vector 1 and 1 which looks like this vector. After multiplication the output vector becomes 2 and 3. This means the original vector 1 and one got stretched and it was also rotated a bit. In short it transforms your input vector into another vector which we call output vector. That's when ideas like rank, nullity, null space and column space start popping up. Okay, let us start with column space. In most places, column space is simply defined as the span of its column vectors. And that's it, which often leaves us confused, wondering what it even means. So here's the most basic way to think about it. Where can this matrix take me? Okay, consider this matrix A. Now let us take any random input vector say 2a 5 which will lie somewhere here. When you multiply this vector with this matrix you get the result as 12A 36 which we can also rewrite as 12 * 1a 3 and it will lie somewhere here. Now let us take any random input vector say min -1 comma 2 which will lie somewhere here. When you multiply this vector with this matrix you get the result as 3a 9 which we can also rewrite as 3 * 1a 3 and it will also lie somewhere here. This way if we take any vector a comma b on this plane we will get this on multiplication with this matrix. Now if we take a + 2 * b as common we get a + 2 * b * 1a 3. So what do you observe? No matter what input vector we choose, whether it's 2 comma 5 or minus one comma 2 or anything else like a comma b, the output always ends up as some multiple of the vector 1 comma 3. That's interesting. In other words, this matrix can only take us along one specific line in space, the line spanned by the vector 1, 3. That line is what we call the column space of this matrix. It's the set of all possible outputs you can get by multiplying this matrix with any input vector. Check closely. The second column is just two times the first one or it is linearly dependent upon the first column. That means both columns lie along the same line. So no matter what combination of them you take, you'll always get a point on that line. A matrix is made of columns. Like if we have a matrix A as A, B, C and D and if we multiply it with an input vector X and Y, then we get this as the result. Right? We can also split and rewrite it like this. So taking X as common, we get this as X * A comma C + Y * B comma D. So it is clear that the output vector is nothing but the set of all linear combinations of the columns of the matrix A. That's it. Now this definition will make much more sense. Column space is the span of its column vectors because when you multiply a matrix by any input vector, all you're really doing is mixing its columns in different proportions. So in our case the column space of this matrix A is the span of the vector 1 comma 3 which we write like this. Now consider this matrix. We can represent its columns like this which will look like these on a graph. These are independent columns which means they're not multiples of each other. Now let us multiply 2 and 5 with this one. We get 12 and 19 which lies somewhere here. I know these vectors are not drawn perfectly to scale and they also might not show the exact directions but that's totally okay. The point here is not to make an accurate geometric diagram but to build a visual intuition. We just want to see what's going on. Now multiply -1a 2 and we get 3a 4 which will lie somewhere here. So this means that the output spread out across the plane. So the matrix can reach any point in the 2D space. It's not restricted to just a line like before. Why? Because its columns are linearly independent. That means they point in different directions and together they can cover the whole plane through linear combinations. So if you imagine all possible outputs you can get from this matrix by plugging in every possible input vector, you'd get the entire 2D space. Thus the column space of the matrix is all of R 2 which we write like this. So it's not just a line anymore. It's the whole plane. Now consider this matrix. Look at its columns. Now tell me in the comments what will be the column space of this matrix. Think about how the columns are related to each other. Are any of them multiples of the others? By the way, when it comes to finding the column space of a matrix, you'll often come across the row reduction method, and you'll find this approach online everywhere. However, I wasn't interested in just showing you the method. That's something you can easily look up. Instead, what I want to emphasize was the visual intuition behind it. If the column space concept is clear, then understanding the rank of a matrix will be a piece of cake for you. Rank is simply the number of linearly independent columns in the matrix. Or in other words, how many directions in space the matrix can actually reach. In our first example, even though the matrix had two columns, they were pointing in the same direction, 1, 3, and the other column was just a multiple of the first column. That means the matrix could only reach points along a single line. So the rank of this matrix is one. But in the second matrix, the columns were not multiples of each other. They were independent, which means they pointed in different directions and could be combined to reach any point in the 2D space. Since there are two such independent columns, the rank of that matrix is two. So you can think of rank as measuring the dimensions of the output space which means the output vector can lie on a line or 1D. So rank is one or on a plane which is 2D or rank two or even higher. And yes it can even lie on a single point the origin when the matrix sends every input to zero. In that case the output space has no dimension at all and the rank is zero. That's what happens for example with a zero matrix where no matter what input you give the output is always just zero double noise. Let's talk about the next topic which is null space of a matrix. Imagine this. You multiply any input vector with this matrix. Do all the matrix multiplication and the result is always just 0 comma 0 as if nothing happened. That collection of all such input vectors is what we call the null space. So while column space and rank is all about the output vector, the null space is all about the input vectors that go to 0 comma 0 or it simply becomes invisible after passing through the matrix. For example, consider this matrix A. Again when we multiply any input vector x comma y with it we get this vector but we need 0 comma 0 vector and thus we equate this thing to 0 comma 0 to get this equation as zero and this one also as zero but the second equation is just three times the first one. Thus we only get x = -2 y. So we can write input vector x and y as -2 y and y. And by taking y common we get y * -2a 1. That's it. This is the null space of matrix a -2 comma 1 lies somewhere here. So any vector that lies along this line when multiplied with a will always give us 0 comma 0. Now consider this matrix. When we multiply any input vector x comma y with it, we get this vector. Equate this thing to 0 comma 0 to get this equation as 0 and this one also as 0. This gives x = -2 y. Substitute into this equation to get y = 0 and thus x= 0. So the null space contains only the zero vector which means the null space is just a single point or the origin that is 0 comma 0. It's not a line not a plane just a tiny dot sitting at the center. Now what rank is for column space? The same is nullity of null space. Which means the rank of a matrix shows the dimension of its column space and the nullity shows the dimension of its null space. So in this case the nullity of this matrix is one and for this case nullity is zero. Remember the rank of this matrix was one. So here's the cool part. If you add the rank and nullity for this matrix you get 1 + 1 or two. Super cool. Now remember the rank of this matrix was two. So if you add the rank and nullity for this case you will get 2 + 0 which is two as well. And thus no matter the matrix rank plus nullity always equals the number of columns of the matrix. This is called the rank nullity theorem. So for this case we have the column space of this matrix as this because the other two columns are just the multiple of this one or they are linearly dependent upon this first column and thus its rank is one. Also the number of columns in this matrix is three. So even without calculating the null space of this matrix, we can say that the nullity of this matrix will be 3 -1 or 2. By the way, using X, Y and Z as the input vectors, can you find the null space of this matrix and let me know your answer in the comments below. If this video gets 10,000 likes, then I will make another Banger Matrix video like this one. If you enjoy my videos and want to support my channel, consider becoming a Patreon as it helps me create more awesome content for you. Link is in the description. Also, you can support my channel by joining our community and becoming a member. So, good [Music]

8th vid:
https://www.youtube.com/watch?v=v8VSDg_WQlA&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=8
Hey everyone, I've got another quick footnote for you between chapters today. When I've talked about linear transformations so far, I've only really talked about transformations from 2D vectors to other 2D vectors, represented with 2x2 matrices, or from 3D vectors to other 3D vectors, represented with 3x3 matrices. But several commenters have asked about non-square matrices, so I thought I'd take a moment to just show what those mean geometrically. By now in the series, you actually have most of the background you need to start pondering a question like this on your own, but I'll start talking through it just to give a little mental momentum. It's perfectly reasonable to talk about transformations between dimensions, such as one that takes 2D vectors to 3D vectors. Again, what makes one of these linear is that gridlines remain parallel and evenly spaced, and that the origin maps to the origin. What I have pictured here is the input space on the left, which is just 2D space, and the output of the transformation shown on the right. The reason I'm not showing the inputs move over to the outputs like I usually do is not just animation laziness, it's worth emphasizing that 2D vector inputs are very different animals from these 3D vector outputs, living in a completely separate, unconnected space. Encoding one of these transformations with a matrix is really just the same thing as what we've done before. You look at where each basis vector lands, and write the coordinates of the landing spots as the columns of a matrix. For example, what you're looking at here is an output of a transformation that takes i-hat to the coordinates 2, negative 1, negative 2, and j-hat to the coordinates 0, 1, 1. Notice, this means the matrix encoding our transformation has three rows and two columns, which, to use standard terminology, makes it a 3x2 matrix. In the language of last video, the column space of this matrix, the place where all the vectors land, is a 2D plane slicing through the origin of 3D space. But the matrix is still full rank, since the number of dimensions in this column space is the same as the number of dimensions of the input space. So if you see a 3x2 matrix out in the wild, you can know that it has the geometric interpretation of mapping two dimensions to three dimensions, since the two columns indicate that the input space has two basis vectors, and the three rows indicate that the landing spots for each of those basis vectors is described with three separate coordinates. Likewise, if you see a 2x3 matrix with two rows and three columns, what do you think that means? Well, the three columns indicate that you're starting in a space that has three basis vectors, so we're starting in three dimensions, and the two rows indicate that the landing spot for each of those three basis vectors is described with only two coordinates, so they must be landing in two dimensions. So it's a transformation from 3D space onto the 2D plane, a transformation that should feel very uncomfortable if you imagine going through it. You could also have a transformation from two dimensions to one dimension. One-dimensional space is really just the number line, so a transformation like this takes in 2D vectors and spits out numbers. Thinking about grid lines remaining parallel and evenly spaced is a little bit messy due to all of the squishification happening here, so in this case, the visual understanding for what linearity means is that if you have a line of evenly spaced dots, it would remain evenly spaced once they're mapped onto the number line. One of these transformations is encoded with a 1x2 matrix, each of whose two columns has just a single entry. The two columns represent where the basis vectors land, and each one of those columns requires just one number, the number that that basis vector landed on. This is actually a surprisingly meaningful type of transformation with close ties to the dot product, and I'll be talking about that next video. Until then, I encourage you to play around with this idea on your own, contemplating the meanings of things like matrix multiplication and linear systems of equations in the context of transformations between different dimensions. Have fun!

9th vid:
https://www.youtube.com/watch?v=LyGKycYT2v0&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=9
[00:00:16] ["Ode to Joy", by Beethoven, plays to the end of the piano.] Traditionally,
[00:00:20] dot products are something that's introduced really early on in a linear algebra course,
[00:00:24] typically right at the start.
[00:00:26] So it might seem strange that I've pushed them back this far in the series.
[00:00:29] I did this because there's a standard way to introduce the topic,
[00:00:32] which requires nothing more than a basic understanding of vectors,
[00:00:35] but a fuller understanding of the role that dot products play in math can only really be
[00:00:40] found under the light of linear transformations.
[00:00:43] Before that, though, let me just briefly cover the standard way that dot products are
[00:00:47] introduced, which I'm assuming is at least partially review for a number of viewers.
[00:00:51] Numerically, if you have two vectors of the same dimension,
[00:00:55] two lists of numbers with the same lengths, taking their dot product means
[00:00:59] pairing up all of the coordinates, multiplying those pairs together,
[00:01:03] and adding the result.
[00:01:06] So the vector 1, 2 dotted with 3, 4 would be 1 times 3 plus 2 times 4.
[00:01:14] The vector 6, 2, 8, 3 dotted with 1, 8, 5, 3 would be
[00:01:19] 6 times 1 plus 2 times 8 plus 8 times 5 plus 3 times 3.
[00:01:24] Luckily, this computation has a really nice geometric interpretation.
[00:01:29] To think about the dot product between two vectors, v and w,
[00:01:33] imagine projecting w onto the line that passes through the origin and the tip of v.
[00:01:38] Multiplying the length of this projection by the length of v,
[00:01:42] you have the dot product v dot w.
[00:01:46] Except when this projection of w is pointing in the opposite direction from v,
[00:01:50] that dot product will actually be negative.
[00:01:53] So when two vectors are generally pointing in the same direction,
[00:01:56] their dot product is positive.
[00:01:59] When they're perpendicular, meaning the projection of one
[00:02:02] onto the other is the zero vector, their dot product is zero.
[00:02:05] And if they point in generally the opposite direction, their dot product is negative.
[00:02:11] Now, this interpretation is weirdly asymmetric.
[00:02:14] It treats the two vectors very differently.
[00:02:16] So when I first learned this, I was surprised that order doesn't matter.
[00:02:20] You could instead project v onto w, multiply the length of
[00:02:24] the projected v by the length of w, and get the same result.
[00:02:30] I mean, doesn't that feel like a really different process?
[00:02:35] Here's the intuition for why order doesn't matter.
[00:02:38] If v and w happened to have the same length, we could leverage some symmetry.
[00:02:43] Since projecting w onto v, then multiplying the length of that projection
[00:02:47] by the length of v, is a complete mirror image of projecting v onto w,
[00:02:51] then multiplying the length of that projection by the length of w.
[00:02:57] Now, if you scale one of them, say v, by some constant like 2,
[00:03:00] so that they don't have equal length, the symmetry is broken.
[00:03:05] But let's think through how to interpret the dot product between this new vector,
[00:03:09] 2 times v, and w.
[00:03:10] If you think of w as getting projected onto v,
[00:03:14] then the dot product 2v dot w will be exactly twice the dot product v dot w.
[00:03:20] This is because when you scale v by 2, it doesn't change the length of the
[00:03:24] projection of w, but it doubles the length of the vector that you're projecting onto.
[00:03:30] But on the other hand, let's say you were thinking about v getting projected onto w.
[00:03:34] Well, in that case, the length of the projection is the thing that gets scaled when we
[00:03:38] multiply v by 2, but the length of the vector that you're projecting onto stays constant.
[00:03:43] So the overall effect is still to just double the dot product.
[00:03:47] So even though symmetry is broken in this case,
[00:03:49] the effect that this scaling has on the value of the dot product is the same
[00:03:53] under both interpretations.
[00:03:56] There's also one other big question that confused me when I first learned this stuff.
[00:04:00] Why on earth does this numerical process of matching coordinates,
[00:04:04] multiplying pairs, and adding them together have anything to do with projection?
[00:04:10] Well, to give a satisfactory answer, and also to do full justice to
[00:04:14] the significance of the dot product, we need to unearth something a
[00:04:17] little bit deeper going on here, which often goes by the name duality.
[00:04:22] But before getting into that, I need to spend some time talking about linear
[00:04:25] transformations from multiple dimensions to one dimension, which is just the number line.
[00:04:32] These are functions that take in a 2D vector and spit out some number,
[00:04:35] but linear transformations are of course much more restricted than
[00:04:39] your run-of-the-mill function with a 2D input and a 1D output.
[00:04:43] As with transformations in higher dimensions, like the ones I talked about in chapter 3,
[00:04:47] there are some formal properties that make these functions linear,
[00:04:50] but I'm going to purposefully ignore those here so as to not distract from our end goal,
[00:04:54] and instead focus on a certain visual property that's equivalent to all the formal stuff.
[00:04:59] If you take a line of evenly spaced dots and apply a transformation,
[00:05:03] a linear transformation will keep those dots evenly spaced once
[00:05:07] they land in the output space, which is the number line.
[00:05:12] Otherwise, if there's some line of dots that gets unevenly spaced,
[00:05:15] then your transformation is not linear.
[00:05:19] As with the cases we've seen before, one of these linear transformations is
[00:05:23] completely determined by where it takes i-hat and j-hat,
[00:05:26] but this time each one of those basis vectors just lands on a number,
[00:05:30] so when we record where they land as the columns of a matrix,
[00:05:34] each of those columns just has a single number.
[00:05:38] This is a 1x2 matrix.
[00:05:41] Let's walk through an example of what it means
[00:05:43] to apply one of these transformations to a vector.
[00:05:46] Let's say you have a linear transformation that takes i-hat to 1 and j-hat to negative 2.
[00:05:52] To follow where a vector with coordinates, say, 4, 3 ends up,
[00:05:56] think of breaking up this vector as 4 times i-hat plus 3 times j-hat.
[00:06:01] A consequence of linearity is that after the transformation,
[00:06:05] the vector will be 4 times the place where i-hat lands, 1,
[00:06:09] plus 3 times the place where j-hat lands, negative 2,
[00:06:12] which in this case implies that it lands on negative 2.
[00:06:18] When you do this calculation purely numerically, it's matrix vector multiplication.
[00:06:25] Now, this numerical operation of multiplying a 1x2 matrix by
[00:06:29] a vector feels just like taking the dot product of two vectors.
[00:06:33] Doesn't that 1x2 matrix just look like a vector that we tipped on its side?
[00:06:37] In fact, we could say right now that there's a nice association between 1x2 matrices
[00:06:42] and 2D vectors, defined by tilting the numerical representation of a vector on its side
[00:06:47] to get the associated matrix, or to tip the matrix back up to get the associated vector.
[00:06:53] Since we're just looking at numerical expressions right now,
[00:06:56] going back and forth between vectors and 1x2 matrices might feel like a silly thing to do.
[00:07:01] But this suggests something that's truly awesome from the geometric view.
[00:07:05] There's some kind of connection between linear transformations
[00:07:08] that take vectors to numbers and vectors themselves.
[00:07:14] Let me show an example that clarifies the significance,
[00:07:17] and which just so happens to also answer the dot product puzzle from earlier.
[00:07:22] Unlearn what you have learned, and imagine that you don't
[00:07:24] already know that the dot product relates to projection.
[00:07:28] What I'm going to do here is take a copy of the number line and place
[00:07:32] it diagonally in space somehow, with the number 0 sitting at the origin.
[00:07:36] Now think of the two-dimensional unit vector whose
[00:07:39] tip sits where the number 1 on the number is.
[00:07:42] I want to give that guy a name, u-hat.
[00:07:45] This little guy plays an important role in what's about to happen,
[00:07:48] so just keep him in the back of your mind.
[00:07:50] If we project 2d vectors straight onto this diagonal number line,
[00:07:54] in effect, we've just defined a function that takes 2d vectors to numbers.
[00:07:59] What's more, this function is actually linear,
[00:08:02] since it passes our visual test that any line of evenly spaced dots remains evenly
[00:08:06] spaced once it lands on the number line.
[00:08:11] Just to be clear, even though I've embedded the number line in 2d space like this,
[00:08:16] the outputs of the function are numbers, not 2d vectors.
[00:08:19] You should think of a function that takes in two
[00:08:21] coordinates and outputs a single coordinate.
[00:08:25] But that vector u-hat is a two-dimensional vector, living in the input space.
[00:08:29] It's just situated in such a way that overlaps with the embedding of the number line.
[00:08:34] With this projection, we just defined a linear transformation from 2d vectors to numbers,
[00:08:39] so we're going to be able to find some kind of 1x2 matrix that
[00:08:42] describes that transformation.
[00:08:45] To find that 1x2 matrix, let's zoom in on this diagonal number
[00:08:49] line setup and think about where i-hat and j-hat each land,
[00:08:52] since those landing spots are going to be the columns of the matrix.
[00:08:58] This part's super cool.
[00:08:59] We can reason through it with a really elegant piece of symmetry.
[00:09:03] Since i-hat and u-hat are both unit vectors, projecting i-hat onto the line
[00:09:07] passing through u-hat looks totally symmetric to projecting u-hat onto the x-axis.
[00:09:13] So when we ask what number does i-hat land on when it gets projected,
[00:09:17] the answer is going to be the same as whatever u-hat lands on when it's projected
[00:09:21] onto the x-axis.
[00:09:22] But projecting u-hat onto the x-axis just means taking the x-coordinate of u-hat.
[00:09:29] So by symmetry, the number where i-hat lands when it's projected onto
[00:09:32] that diagonal number line is going to be the x-coordinate of u-hat.
[00:09:37] Isn't that cool?
[00:09:39] The reasoning is almost identical for the j-hat case.
[00:09:42] Think about it for a moment.
[00:09:49] For all the same reasons, the y-coordinate of u-hat gives us the
[00:09:52] number where j-hat lands when it's projected onto the number line copy.
[00:09:57] Pause and ponder that for a moment.
[00:09:58] I just think that's really cool.
[00:10:00] So the entries of the 1x2 matrix describing the projection
[00:10:04] transformation are going to be the coordinates of u-hat.
[00:10:08] And computing this projection transformation for arbitrary vectors in space,
[00:10:12] which requires multiplying that matrix by those vectors,
[00:10:15] is computationally identical to taking a dot product with u-hat.
[00:10:21] This is why taking the dot product with a unit vector can be interpreted as
[00:10:26] projecting a vector onto the span of that unit vector and taking the length.
[00:10:34] So what about non-unit vectors?
[00:10:36] For example, let's say we take that unit vector u-hat,
[00:10:38] but we scale it up by a factor of 3.
[00:10:41] Numerically, each of its components gets multiplied by 3.
[00:10:44] So looking at the matrix associated with that vector,
[00:10:47] it takes i-hat and j-hat to three times the values where they landed before.
[00:10:55] Since this is all linear, it implies more generally that the new matrix can be
[00:10:59] interpreted as projecting any vector onto the number line copy and multiplying where it
[00:11:04] lands by 3.
[00:11:05] This is why the dot product with a non-unit vector can be
[00:11:08] interpreted as first projecting onto that vector,
[00:11:11] then scaling up the length of that projection by the length of the vector.
[00:11:17] Take a moment to think about what happened here.
[00:11:19] We had a linear transformation from 2D space to the number line,
[00:11:23] which was not defined in terms of numerical vectors or numerical dot products,
[00:11:26] it was just defined by projecting space onto a diagonal copy of the number line.
[00:11:31] But because the transformation is linear, it was necessarily described by some 1x2 matrix.
[00:11:37] And since multiplying a 1x2 matrix by a 2D vector is the same
[00:11:40] as turning that matrix on its side and taking a dot product,
[00:11:44] this transformation was inescapably related to some 2D vector.
[00:11:49] The lesson here is that any time you have one of these linear transformations whose
[00:11:53] output space is the number line, no matter how it was defined,
[00:11:56] there's going to be some unique vector v corresponding to that transformation,
[00:12:00] in the sense that applying the transformation is the same thing as taking a dot
[00:12:05] product with that vector.
[00:12:09] To me, this is utterly beautiful.
[00:12:12] It's an example of something in math called duality.
[00:12:16] Duality shows up in many different ways and forms throughout math,
[00:12:19] and it's super tricky to actually define.
[00:12:22] Loosely speaking, it refers to situations where you have a natural
[00:12:26] but surprising correspondence between two types of mathematical thing.
[00:12:31] For the linear algebra case that you just learned about,
[00:12:34] you'd say that the dual of a vector is the linear transformation that it encodes,
[00:12:38] and the dual of a linear transformation from some space to one dimension is a
[00:12:43] certain vector in that space.
[00:12:46] So to sum up, on the surface, the dot product is a very useful
[00:12:50] geometric tool for understanding projections and for testing
[00:12:53] whether or not vectors tend to point in the same direction.
[00:12:56] And that's probably the most important thing for you to remember about the dot product.
[00:13:01] But at a deeper level, dotting two vectors together is a way
[00:13:04] to translate one of them into the world of transformations.
[00:13:08] Again, numerically, this might feel like a silly point to emphasize.
[00:13:11] It's just two computations that happen to look similar.
[00:13:14] But the reason I find this so important is that throughout math,
[00:13:18] when you're dealing with a vector, once you really get to know its personality,
[00:13:22] sometimes you realize that it's easier to understand it not as an arrow in space,
[00:13:26] but as the physical embodiment of a linear transformation.
[00:13:30] It's as if the vector is really just a conceptual shorthand for a certain transformation,
[00:13:35] since it's easier for us to think about arrows in space rather than
[00:13:38] moving all of that space to the number line.
[00:13:42] In the next video, you'll see another really cool example of this duality in action,
[00:13:47] as I talk about the cross product.

10th vid:
https://www.youtube.com/watch?v=eu6i7WJeinw&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=10
[00:00:09] Last video I talked about the dot product, showing both the standard introduction
[00:00:13] to the topic, as well as a deeper view of how it relates to linear transformations.
[00:00:18] I'd like to do the same thing for cross products,
[00:00:21] which also have a standard introduction, along with a deeper understanding
[00:00:24] in the light of linear transformations, but this time I'm dividing it into
[00:00:27] two separate videos.
[00:00:29] Here, I'll try to hit the main points that students are usually shown
[00:00:33] about the cross product, and in the next video I'll be showing a view
[00:00:36] which is less commonly taught, but really satisfying when you learn it.
[00:00:40] We'll start in two dimensions.
[00:00:42] If you have two vectors, v and w, think about the parallelogram that they span out.
[00:00:47] What I mean by that is that if you take a copy of v and move its tail to the tip of w,
[00:00:53] and you take a copy of w and move its tail to the tip of v,
[00:00:56] the four vectors now on the screen enclose a certain parallelogram.
[00:01:02] The cross product of v and w, written with the x-shaped multiplication symbol,
[00:01:06] is the area of this parallelogram.
[00:01:10] Well, almost.
[00:01:11] We also need to consider orientation.
[00:01:14] Basically, if v is on the right of w, then v cross w
[00:01:17] is positive and equal to the area of the parallelogram.
[00:01:21] But if v is on the left of w, then the cross product is negative,
[00:01:25] namely the negative area of that parallelogram.
[00:01:28] Notice this means that order matters.
[00:01:31] If you swapped v and w, instead taking w cross v,
[00:01:33] the cross product would become the negative of whatever it was before.
[00:01:39] The way I always remember the ordering here is that when you take the cross product
[00:01:43] of the two basis vectors in order, i-hat cross j-hat, the result should be positive.
[00:01:48] In fact, the order of your basis vectors is what defines orientation.
[00:01:52] So since i-hat is on the right of j-hat, I remember that v
[00:01:56] cross w has to be positive whenever v is on the right of w.
[00:02:01] So for example, with the vectors shown here, I'll just
[00:02:04] tell you that the area of that parallelogram is seven.
[00:02:07] And since v is on the left of w, the cross product should be negative.
[00:02:11] So v cross w is negative seven.
[00:02:15] But of course, you want to be able to compute this without someone telling you the area.
[00:02:20] This is where the determinant comes in.
[00:02:23] So if you didn't see chapter five of this series,
[00:02:25] where I talk about the determinant, now would be a really good time to go take a look.
[00:02:29] Even if you did see it, but it was a while ago,
[00:02:31] I'd recommend taking another look just to make sure those ideas are fresh in your mind.
[00:02:37] For the 2D cross product, v cross w, what you do is you write the coordinates
[00:02:41] of v as the first column of a matrix, and you take the coordinates of w
[00:02:45] and make them the second column, then you just compute the determinant.
[00:02:51] This is because a matrix whose columns represent v and w corresponds with a
[00:02:56] linear transformation that moves the basis vectors i-hat and j-hat to v and w.
[00:03:06] The determinant is all about measuring how areas change due to a transformation,
[00:03:11] and the prototypical area that we look at is the unit square resting on i-hat and j-hat.
[00:03:17] After the transformation, that square gets turned
[00:03:19] into the parallelogram that we care about.
[00:03:22] So the determinant, which generally measures the factor by which areas are changed,
[00:03:26] gives the area of this parallelogram, since it evolved from a square that started with
[00:03:31] area one.
[00:03:32] What's more, if v is on the left of w, it means that orientation was flipped during
[00:03:37] that transformation, which is what it means for the determinant to be negative.
[00:03:43] As an example, let's say v has coordinates negative 3, 1, and w has coordinates 2, 1.
[00:03:50] The determinant of the matrix with those coordinates as columns
[00:03:56] is negative 3 times 1 minus 2 times 1, which is negative 5.
[00:04:01] So evidently, the area of the parallelogram they define is 5,
[00:04:05] and since v is on the left of w, it should make sense that this value is negative.
[00:04:11] As with any new operation you learn, I'd recommend playing
[00:04:13] around with this notion a bit in your head, just to get kind
[00:04:16] of an intuitive feel for what the cross product is all about.
[00:04:19] For example, you might notice that when two vectors are perpendicular,
[00:04:23] or at least close to being perpendicular, their cross product is larger than
[00:04:27] it would be if they were pointing in very similar directions,
[00:04:30] because the area of that parallelogram is larger when the sides are closer to
[00:04:34] being perpendicular.
[00:04:37] Something else you might notice is that if you were to scale up one of those vectors,
[00:04:42] perhaps multiplying v by 3, then the area of that parallelogram
[00:04:46] is also scaled up by a factor of 3.
[00:04:49] So what this means for the operation is that 3v
[00:04:52] cross w will be exactly 3 times the value of v cross w.
[00:04:58] Now, even though all of this is a perfectly fine mathematical operation,
[00:05:01] what I just described is technically not the cross product.
[00:05:05] The true cross product is something that combines
[00:05:08] two different 3d vectors to get a new 3d vector.
[00:05:12] Just as before, we're still going to consider the parallelogram
[00:05:15] defined by the two vectors that we're crossing together,
[00:05:18] and the area of this parallelogram is still going to play a big role.
[00:05:22] To be concrete, let's say that the area is 2.5 for the vectors shown here.
[00:05:27] But as I said, the cross product is not a number, it's a vector.
[00:05:30] This new vector's length will be the area of that parallelogram,
[00:05:34] which in this case is 2.5, and the direction of that new vector is going to be
[00:05:39] perpendicular to the parallelogram.
[00:05:42] But which way, right?
[00:05:44] I mean, there are two possible vectors with length
[00:05:46] 2.5 that are perpendicular to a given plane.
[00:05:50] This is where the right hand rule comes in.
[00:05:53] Point the forefinger of your right hand in the direction of v,
[00:05:56] then stick out your middle finger in the direction of w.
[00:05:59] Then, when you point up your thumb, that's the direction of the cross product.
[00:06:08] For example, let's say that v was a vector with length 2 pointing straight up in
[00:06:12] the z direction, and w is a vector with length 2 pointing in the pure y direction.
[00:06:17] The parallelogram that they define in this simple example is actually a square,
[00:06:21] since they're perpendicular and have the same length, and the area of that square is 4.
[00:06:26] So their cross product should be a vector with length 4.
[00:06:29] Using the right hand rule, their cross product should point in the negative x direction.
[00:06:36] So the cross product of these two vectors is negative 4 times i-hat.
[00:06:45] For more general computations, there is a formula that you could memorize if you wanted,
[00:06:49] but it's common and easier to instead remember a certain
[00:06:52] process involving the 3D determinant.
[00:06:55] Now, this process looks truly strange at first.
[00:06:59] You write down a 3D matrix where the second and
[00:07:01] third columns contain the coordinates of v and w.
[00:07:05] But for that first column, you write the basis vectors i-hat, j-hat, and k-hat.
[00:07:11] Then you compute the determinant of this matrix.
[00:07:15] The silliness is probably clear here.
[00:07:17] What on earth does it mean to put in a vector as the entry of a matrix?
[00:07:20] Students are often told that this is just a notational trick.
[00:07:25] When you carry out the computations as if i-hat, j-hat, and k-hat were numbers,
[00:07:29] then you get some linear combination of those basis vectors.
[00:07:35] And the vector defined by that linear combination, students are told to just believe,
[00:07:40] is the unique vector perpendicular to v and w,
[00:07:43] whose magnitude is the area of the appropriate parallelogram,
[00:07:46] and whose direction obeys the right hand rule.
[00:07:51] And sure, in some sense this is just a notational trick,
[00:07:54] but there is a reason for doing it.
[00:07:58] It's not just a coincidence that the determinant is once again important.
[00:08:01] And putting the basis vectors in those slots is not just a random thing to do.
[00:08:06] To understand where all of this comes from, it helps to
[00:08:09] use the idea of duality that I introduced in the last video.
[00:08:12] This concept is a little bit heavy though, so I'm putting it in a
[00:08:15] separate follow-on video for any of you who are curious to learn more.
[00:08:19] Arguably, it falls outside the essence of linear algebra.
[00:08:23] The important part here is to know what that cross
[00:08:25] product vector geometrically represents.
[00:08:28] So if you want to skip that next video, feel free.
[00:08:30] But for those of you who are willing to go a bit deeper,
[00:08:33] and who are curious about the connection between this computation and the underlying
[00:08:36] geometry, the ideas that I'll talk about in the next video are just a really
[00:08:40] elegant piece of math.


11th vid:
https://www.youtube.com/watch?v=BaM7OCEm3G0&list=PLZHQObOWTQDPD3MizzM2xVFitgF8hE_ab&index=11
[00:00:16] Hey folks, where we left off I was talking about how to compute
[00:00:20] a three-dimensional cross product between two vectors, v cross w.
[00:00:25] It's this funny thing where you write a matrix whose second column has the
[00:00:29] coordinates of v, whose third column has the coordinates of w,
[00:00:33] but the entries of that first column, weirdly, are the symbols i-hat, j-hat,
[00:00:37] and k-hat, where you just pretend like those guys are numbers for the sake
[00:00:41] of computations.
[00:00:43] Then with that funky matrix in hand, you compute its determinant.
[00:00:48] If you just chug along with those computations, ignoring the weirdness,
[00:00:52] you get some constant times i-hat, plus some constant times j-hat,
[00:00:55] plus some constant times k-hat.
[00:00:59] How specifically you think about computing that determinant is kind of beside the point.
[00:01:04] All that really matters here is that you'll end up with three different
[00:01:08] numbers that are interpreted as the coordinates of some resulting vector.
[00:01:13] From here, students are typically told to just believe that
[00:01:16] the resulting vector has the following geometric properties.
[00:01:20] Its length equals the area of the parallelogram defined by v and w.
[00:01:25] It points in a direction perpendicular to both v and w,
[00:01:28] and this direction obeys the right-hand rule, in the sense that if
[00:01:32] you point your forefinger along v and your middle finger along w,
[00:01:36] then when you stick up your thumb, it'll point in the direction of the new vector.
[00:01:43] There are some brute force computations that you could do to confirm these facts,
[00:01:47] but I want to share with you a really elegant line of reasoning.
[00:01:51] It leverages a bit of background, though, so for this video
[00:01:54] I'm assuming that everybody has watched chapter 5 on the determinant and chapter 7,
[00:01:58] where I introduced the idea of duality.
[00:02:04] As a quick reminder, the idea of duality is that any time you have a
[00:02:08] linear transformation from some space to the number line,
[00:02:11] it's associated with a unique vector in that space,
[00:02:14] in the sense that performing the linear transformation is the same as
[00:02:18] taking a dot product with that vector.
[00:02:22] Numerically, this is because one of those transformations is described by a matrix with
[00:02:27] just one row, where each column tells you the number that each basis vector lands on.
[00:02:35] And multiplying this matrix by some vector v is computationally identical to taking
[00:02:40] the dot product between v and the vector you get by turning that matrix on its side.
[00:02:46] The takeaway is that whenever you're out in the mathematical wild and you find
[00:02:50] a linear transformation to the number line, you will be able to match it to some vector,
[00:02:55] which is called the dual vector of that transformation,
[00:02:58] so that performing the linear transformation is the same as taking a dot product
[00:03:02] with that vector.
[00:03:06] The cross product gives us a really slick example of this process in action.
[00:03:10] It takes some effort, but it's definitely worth it.
[00:03:13] What I'm going to do is define a certain linear transformation from three dimensions
[00:03:18] to the number line, and it'll be defined in terms of the two vectors v and w.
[00:03:23] Then when we associate that transformation with its dual vector in 3D space,
[00:03:28] that dual vector is going to be the cross product of v and w.
[00:03:33] The reason for doing this will be that understanding that transformation is going to
[00:03:37] make clear the connection between the computation and the geometry of the cross product.
[00:03:44] So to back up a bit, remember in two dimensions what
[00:03:47] it meant to compute the 2D version of the cross product?
[00:03:50] When you have two vectors v and w, you put the coordinates of v as the first
[00:03:55] column of a matrix and the coordinates of w as the second column of a matrix.
[00:03:59] Then you just compute the determinant.
[00:04:01] There's no nonsense with basis vectors stuck in a matrix or anything like that,
[00:04:05] just an ordinary determinant returning a number.
[00:04:09] Geometrically, this gives us the area of a parallelogram spanned out by those two
[00:04:13] vectors, with the possibility of being negative depending on the orientation of the
[00:04:18] vectors.
[00:04:19] Now, if you didn't already know the 3D cross product and you're trying to extrapolate,
[00:04:25] you might imagine that it involves taking three separate 3D vectors,
[00:04:29] u, v, and w, and making their coordinates the columns of a 3x3 matrix,
[00:04:34] then computing the determinant of that matrix.
[00:04:38] And as you know from chapter 5, geometrically this would give you the volume
[00:04:43] of a parallelepiped spanned out by those three vectors,
[00:04:46] with a plus or minus sign depending on the right hand rule orientation of
[00:04:51] those three vectors.
[00:04:53] Of course, you all know that this is not the 3D cross product.
[00:04:56] The actual 3D cross product takes in two vectors and spits out a vector.
[00:05:02] It doesn't take in three vectors and spit out a number.
[00:05:05] But this idea actually gets us really close to what the real cross product is.
[00:05:10] Consider that first vector u to be a variable,
[00:05:14] say with variable entries x, y, and z, while v and w remain fixed.
[00:05:22] What we have then is a function from three dimensions to the number line.
[00:05:27] You input some vector x, y, z and you get out a number by taking
[00:05:31] the determinant of a matrix whose first column is x, y,
[00:05:34] z and whose other two columns are the coordinates of the constant vectors v and w.
[00:05:40] Geometrically, the meaning of this function is that for any input vector x,
[00:05:46] y, z, you consider the parallelepiped defined by this vector v and w.
[00:05:51] Then you return its volume with a plus or minus sign depending on orientation.
[00:05:57] Now, this might feel like kind of a random thing to do.
[00:06:00] I mean, where does this function come from?
[00:06:01] Why are we defining it this way?
[00:06:03] And I'll admit, at this stage it might kind of feel like it's coming out of the blue.
[00:06:06] But if you're willing to go along with it and play around with the
[00:06:09] properties that this guy has, it's the key to understanding the cross product.
[00:06:15] One really important fact about this function is that it's linear.
[00:06:20] I'll actually leave it to you to work through the details
[00:06:22] of why this is true based on properties of the determinant.
[00:06:26] But once you know that it's linear, we can start bringing in the idea of duality.
[00:06:35] Once you know that it's linear, you know that there's some
[00:06:37] way to describe this function as matrix multiplication.
[00:06:41] Specifically, since it's a function that goes from three dimensions to one dimension,
[00:06:46] there will be a one by three matrix that encodes this transformation.
[00:06:53] And the whole idea of duality is that the special thing about transformations from
[00:06:57] several dimensions to one dimension is that you can turn that matrix on its side and
[00:07:02] instead interpret the entire transformation as the dot product with a certain vector.
[00:07:07] What we're looking for is the special 3D vector that I'll call p such that taking
[00:07:13] the dot product between p and any other vector x, y,
[00:07:16] z gives the same result as plugging in x, y, z as the first column of a three
[00:07:21] by three matrix whose other two columns have the coordinates of v and w,
[00:07:26] then computing the determinant.
[00:07:29] I'll get to the geometry of this in just a moment,
[00:07:31] but right now let's dig in and think about what this means computationally.
[00:07:35] Taking the dot product between p and x, y, z will give us something times x plus
[00:07:41] something times y plus something times z, where those somethings are the coordinates of p.
[00:07:47] But on the right side here, when you compute the determinant,
[00:07:51] you can organize it to look like some constant times x plus some constant times y
[00:07:56] plus some constant times z, where those constants involve certain combinations of
[00:08:01] the components of v and w.
[00:08:03] So those constants, those particular combinations of the coordinates of v
[00:08:08] and w are going to be the coordinates of the vector p that we're looking for.
[00:08:18] But what's going on on the right here should feel very familiar to
[00:08:21] anyone who's actually worked through a cross product computation.
[00:08:25] Collecting the constant terms that are multiplied by x, y,
[00:08:29] and by z like this is no different from plugging in the symbols i-hat, j-hat,
[00:08:33] and k-hat to that first column, and seeing which coefficients aggregate on each
[00:08:38] one of those terms.
[00:08:40] It's just that plugging in i-hat, j-hat, and k-hat is a way of signaling
[00:08:45] that we should interpret those coefficients as the coordinates of a vector.
[00:08:51] So what all of this is saying is that this funky computation
[00:08:54] can be thought of as a way to answer the following question.
[00:08:57] What vector p has the special property that when you take a dot
[00:09:01] product between p and some vector x, y, z, it gives the same result as plugging in x,
[00:09:07] y, z to the first column of a matrix whose other two columns have
[00:09:11] the coordinates of v and w, then computing the determinant.
[00:09:15] That's a bit of a mouthful, but it's an important question to digest for this video.
[00:09:21] Now for the cool part, which ties all this together with the geometric
[00:09:24] understanding of the cross product that I introduced last video.
[00:09:28] I'm going to ask the same question again, but this time we're
[00:09:31] going to try to answer it geometrically instead of computationally.
[00:09:36] What 3D vector p has the special property that when you take a dot product between
[00:09:42] p and some other vector x, y, z, it gives the same result as if you took the signed
[00:09:48] volume of a parallelepiped defined by this vector x, y, z along with v and w.
[00:09:57] Remember, the geometric interpretation of a dot product between a
[00:10:01] vector p and some other vector is to project that other vector onto p,
[00:10:06] then to multiply the length of that projection by the length of p.
[00:10:13] With that in mind, let me show a certain way to think
[00:10:16] about the volume of the parallelepiped that we care about.
[00:10:20] Start by taking the area of the parallelogram defined by v and w,
[00:10:24] then multiply it not by the length of x, y, z, but by the component of x,
[00:10:29] y, z that's perpendicular to that parallelogram.
[00:10:34] In other words, the way our linear function works on a given vector is to project
[00:10:39] that vector onto a line that's perpendicular to both v and w,
[00:10:43] then to multiply the length of that projection by the area of the parallelogram
[00:10:48] spanned by v and w.
[00:10:51] But this is the same thing as taking a dot product between x, y,
[00:10:55] z and a vector that's perpendicular to v and w with a length equal to the area of
[00:11:00] that parallelogram.
[00:11:03] What's more, if you choose the appropriate direction for that vector,
[00:11:07] the cases where the dot product is negative will line up with the cases
[00:11:11] where the right hand rule for the orientation of x, y, z, v and w is negative.
[00:11:19] This means that we just found a vector p so that taking a dot product
[00:11:24] between p and some vector x, y, z is the same thing as computing that
[00:11:29] determinant of a 3x3 matrix whose columns are x, y, z, the coordinates of v and w.
[00:11:35] So the answer that we found earlier computationally using that
[00:11:39] special notational trick must correspond geometrically to this vector.
[00:11:43] This is the fundamental reason why the computation and the
[00:11:47] geometric interpretation of the cross product are related.
[00:11:52] Just to sum up what happened here, I started by defining a linear transformation
[00:11:57] from 3D space to the number line, and it was defined in terms of the vectors v and w.
[00:12:03] Then I went through two separate ways to think about the dual vector
[00:12:06] of this transformation, the vector such that applying the transformation
[00:12:10] is the same thing as taking a dot product with that vector.
[00:12:14] On the one hand, a computational approach will lead you to
[00:12:17] the trick of plugging in the symbols i-hat, j-hat,
[00:12:20] and k-hat to the first column of a matrix and computing the determinant.
[00:12:26] But thinking geometrically, we can deduce that this dual vector
[00:12:29] must be perpendicular to v and w with a length equal to the
[00:12:33] area of the parallelogram spanned out by those two vectors.
[00:12:39] Since both of these approaches give us a dual vector to the same transformation,
[00:12:43] they must be the same vector.
[00:12:47] So that wraps up dot products and cross products,
[00:12:49] and the next video will be a really important concept for linear algebra, change of basis.

Cross product exists only in 3D (and a special 7D case)




Cross product exists only in 3D (and a special 7D case)  means?

This is a fascinating fact from mathematics.

When we say cross product, we usually mean an operation

×:R
n
×R
n
→R
n

that satisfies these properties:

a×b is perpendicular to both a and b.
∣a×b∣=∣a∣∣b∣sinθ (its length equals the parallelogram area).
It is bilinear (linear in each argument).
a×b=−b×a.

The surprising theorem is:

Such an operation exists only when n=3 and, in a more exotic form, when n=7.

Why not in 2D?

In 2D, the vectors lie in a plane.

↑ y
|
|   b
|  /
| /
|/_____→ x
   a

A vector perpendicular to both should point out of the page.

But in 2D there is no third direction!

So there is no vector inside R
2
 that is perpendicular to both.

Instead, the "2D cross product" is defined as a scalar:

a
x
	​

b
y
	​

−a
y
	​

b
x
	​

.

It gives the signed area, not another 2D vector.

Why does it work in 3D?

In 3D,

      ↑ z
      |
      |  ×
      |
------O------→ x
     /
    /
   y

Given two vectors, there is a unique direction perpendicular to both.

That is exactly where

a×b

points.

Why not in 4D?

Suppose

a,b∈R
4
.

The set of vectors perpendicular to both is not a single direction.

It is actually a 2-dimensional plane.

So there isn't one unique "normal vector."

There are infinitely many.

4D

a,b span a plane

Perpendicular directions:

   ↗
 ←      →
   ↘

Many choices!

Which one should the cross product return?

There is no natural choice.

What about 5D, 6D...?

The same problem occurs.

The perpendicular space has dimension

n−2.
In 3D:
3−2=1

One perpendicular direction.

Perfect!

In 4D:
4−2=2

Two-dimensional family of perpendicular vectors.

No unique answer.

Then why 7D?

This is one of the beautiful surprises in mathematics.

There exists a special number system called the octonions.

The imaginary part of the octonions is 7-dimensional.

Because of the special algebraic properties of octonions, you can define a cross product in R
7
 that satisfies the same key properties as the familiar 3D cross product.

It is not because 7D has a unique perpendicular direction (it doesn't). It's because the octonion algebra provides an extra structure that lets you choose one consistently.

The theorem (Brown & Gray)

A bilinear, anti-symmetric cross product satisfying the usual geometric properties exists only in

R
3
 and R
7
.
	​

TL;DR
2D: No perpendicular vector exists in the plane → only a scalar "cross product."
3D: Exactly one perpendicular direction → the usual vector cross product.
4D, 5D, 6D: Too many perpendicular directions → no unique cross product.
7D: A special exception due to the algebra of octonions, allowing a generalized cross product.

This result is considered one of the elegant "hidden gems" of advanced algebra and geometry.

any thing greater than 7d

No. If you require the usual properties of the cross product, then there is no vector-valued cross product in any dimension greater than 7.

More precisely:

Dimension	Standard cross product exists?
2	❌ (only a scalar signed area)
3	✅ Yes
4	❌ No
5	❌ No
6	❌ No
7	✅ Yes (special, via octonions)
8, 9, 10, ...	❌ No
Why?

For a true cross product, you want:

Input: two vectors.
Output: one vector.
Output is perpendicular to both.
Magnitude equals the parallelogram area.
Bilinear and anti-symmetric.

A deep theorem proves that only 3D and 7D allow all of these simultaneously.

Can we still do something in higher dimensions?

Yes, but not the ordinary cross product.

For example, in 4D:

Instead of returning one vector, mathematicians return a bivector (an oriented plane), using the exterior/wedge product:

u∧v.

This object represents the plane spanned by u and v, not a single perpendicular vector.

This generalizes to every dimension:

∧:R
n
×R
n
→Λ
2
(R
n
)
	​


This is the tool used in modern differential geometry, relativity, and geometric algebra.

Why is 7D special?

The dimensions

1,2,4,8

are the dimensions of the only normed division algebras:

R (real numbers)
C (complex numbers)
H (quaternions)
O (octonions)

The imaginary parts of these algebras have dimensions:

Complex: 1
Quaternions: 3
Octonions: 7

The familiar 3D cross product comes from the imaginary quaternions, and the 7D cross product comes from the imaginary octonions. There are no further normed division algebras, so there are no analogous cross products in higher dimensions.

TL;DR
3D: Ordinary cross product exists.
7D: A special cross product also exists.
All dimensions > 7: No ordinary cross product exists.
Higher dimensions use the wedge (exterior) product instead, which generalizes the idea of "area spanned by two vectors" without trying to produce a single perpendicular vector