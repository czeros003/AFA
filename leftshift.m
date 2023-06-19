function ShiftedVector=leftshift(Vector,LengthOfShift)
%Right Shift
%Shift a vector from position 1 to the end of the vector
LengthOfVector=length(Vector);
for i=1:LengthOfShift
   Temp=Vector(1);
   TempVector=Vector(2:LengthOfVector);
   Vector=[TempVector Temp];
end
ShiftedVector=Vector;