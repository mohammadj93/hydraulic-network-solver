# hydraulic-network-solver
This generic MATLAB code is to solve the pressure, flow rate and concentration distribution in a hydraulic network of channels in microfluidics such as concentration gradient generators or CGGs. 
# How To Use The Code
To use the code only an excel file is needed with the name "Connections.xlsx". This file has two sheets with the following names: "R" which stands for the resistors and "PQC" which contains the boundary conditions of the network, including pressure, flow rate and concentration. At the moment the solver is only able to solve for concentration of one species, however, for multiple species it is reasonable to run the code several times for each species provided that their dynamics is separable from each other (they do not have interactions with one another)

Each of the nodes should be assigned with a unique number (the value and order of the numbers is not important) then the excel sheet with the name "R" will contain properties of the connection between the nodes if there is any. First colomn is from whcih is the number of the starting node of the connection and the second column is the ending node of the connection. The third and forth columns are length and width of the connection respectively. The coneections can be circular pipe in which case the equivalent dimensions must be used. In the case that your microfluidic chip is double layer the height of the chip is not constant for all the connection and you need to change the code. In the code line 6 you need to initialize H or the height of the chip. 

The second sheet "PQC" has four columns. First is the number of the boundary node. The second column is the pressure at the node, the third is the flow rate and the fourth is the concentration. If there is no information available of any of the parameter then the element should be left empty. In general, for the outlet nodes, the pressure is known and it is usually set at zero and for the inlet nodes the concentration is known and the flow rates. 

After running the code, pressures and concentrations at the nodes will pup up in the command window and the data is the workspace that you can use. Keep the dimensions' unit constant through out the sheet and in the code. The amount of flow rate determines the direction of the flow. If the flow rate is positive it means that it flows from the starting node to the edning node and vice versa. You should remember that concentration is calculated with the assumption that between each two nodes with a connection, there is a mixer that will mix the fluid thoroughly for perfect mixing. Please refer to the following paper in the journal Lab On a Chip, to understand the formulation for hydraulic resistance. 

_Design of pressure-driven microfluidic networks using electric circuit analogy <br />
Kwang W. Oh, Kangsun Lee, Byungwook Ahn and Edward P. Furlani_

Follow the demo example to learn how to use the code. The code should result in the floowing answer.

    flow rates        Branch    
    __________    ______________

          40      12     1     2
      18.027      23     2     3
      21.973      24     2     4
      41.705      34     3     4
      76.322      36     3     6
      63.678      45     4     5
     -76.322      56     5     6

    Node     pressure     concentration
    ____    __________    _____________

     1        0.028616           27    
     2        0.024021           27    
     3        0.021521           58    
     4       0.0073148       47.303    
     5      3.2131e-20       53.135    
     6        0.014507           58  

You can cite this as
<a href="https://zenodo.org/badge/latestdoi/524494706"><img src="https://zenodo.org/badge/524494706.svg" alt="DOI"></a>
