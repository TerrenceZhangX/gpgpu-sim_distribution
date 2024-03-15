import torch

print("Hi, this is python code execution")
device = torch.device("cuda")
input = torch.randn(10, 3, 4).to(device)
mat2 = torch.randn(10, 4, 5).to(device)
res = torch.bmm(input, mat2).to("cpu")
print(res.size())
print(res)