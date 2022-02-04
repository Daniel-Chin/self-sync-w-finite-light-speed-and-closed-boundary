# Self synchronization with locality and closed boundaries
[gif]
self-synchronizes into
[gif]

## Intro
Nicky Case made a demo of self-synchronizing fireflies: https://ncase.me/fireflies/  

I want to add two things:
- **Locality**. Light speed is finite. 
- **Closed boundaries**. Here I have tried: 
  - Sphere surface. 
  - Torus surface. 

I wanted to do these simulations because when TCP end hosts do congestion control, they need to synchronize with other hosts to modulate the queue length in gateways. Ideally, the globe should pulsate as a whole. But when information travels at finite speed, how can the hosts synchronize? 

I thought the torus surface would be easier. Imagine uni-directional waves. For the sphere though, I can't imagine any stable pattern, so the Earth's internet may have some trouble finding equilibrium. However, experiments showed the sphere actually did better than the torus. 

## Light speed `c` is infinite
i.e. there is non-local interaction. 

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
