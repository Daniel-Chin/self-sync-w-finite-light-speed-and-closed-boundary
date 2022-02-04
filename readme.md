# Self synchronization with locality and closed boundaries
![before sync](./videos/gif/initial_random.gif)
self-synchronizes into
![after sync](./videos/gif/cheat_3.gif)

## Intro
Nicky Case made a demo of self-synchronizing fireflies: https://ncase.me/fireflies/  

I want to add two things:
- **Locality**. Light speed is finite. 
- **Closed boundaries**. Here I have tried: 
  - Sphere surface. 
  - Torus surface. 

## Motivation
In computer networks, when TCP end hosts do congestion control, they need to synchronize with other hosts to modulate the queue length in gateways. Ideally, the globe should pulsate as a whole. But when information travels at finite speed, how can the hosts synchronize? 

I thought the torus surface would be easier. Imagine uni-directional waves. For the sphere though, I can't imagine any stable pattern, so the Earth's internet may have some trouble finding equilibrium. However, experiments showed the sphere actually did better than the torus. 

## Light speed `c` is infinite
i.e. there is non-local interaction.  
<iframe width="560" height="315" src="https://www.youtube.com/embed/81-LluMBauI" title="YouTube video player" frameborder="0" allow="accelerometer; autoplay; clipboard-write; encrypted-media; gyroscope; picture-in-picture" allowfullscreen></iframe>

Here, both shapes quickly converges to stable patterns. 

## `c = 10`
Slower convergence to stable patterns. 

## `c = 5.7`

## `c = 1.9`

## Ring world
They sometimes converge to a uni-directional looping wave, but sometimes converge to one-source-one-drain waves. 

## Cheating
I can "plant" 20% nodes whose phase I initialized according to a desired wave pattern. They turn out to converge to the planted pattern. 

## `c = 10`

## `c = 10`

## Some longer runs
