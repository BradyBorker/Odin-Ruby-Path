def fibs(n)
  sequence = []
  for i in 0...n
    if i == 0
      sequence.append(0)
    elsif i == 1
      sequence.append(1)
    else
      sequence.append(sequence[-1]+sequence[-2])
    end
  end
  sequence
end

p fibs(8) # => [0,1,1,2,3,5,8,13]

def fibs_rec(n, sequence=[0,1])
  if sequence.length == n
    return sequence
  elsif n <= 2
    return 1
  end
  sequence.append(sequence[-1] + sequence[-2])
  fibs_rec(n, sequence)
end

p fibs_rec(8)