#!/usr/bin/env nextflow
nextflow.enable.dsl=2

process foo {
  input:
    each x

  output:
    val x

  """
  echo $x > file
  """
}


process bar1 {
    input:
      val x

    output:
      val x

    script:
      """
      sleep \$((RANDOM % 7));
      """
}

process bar2 {
    input:
      val x

    output:
      val x

    script:
      """
      sleep \$((RANDOM % 7));
      """
}

process joiner {
    
    input:
      val x1

    output:
      env x3

    script:
      """
      x3="$x1"
      """
}


workflow {
    ch = Channel
        .fromFilePairs( './data/*.txt', size:1 )
        .map { group_key, files -> tuple( group_key, *files ) }

  foo(ch)
  bar1(foo.out)
  bar2(foo.out)
  
  receiver = joiner( bar1.out.cross(bar2.out) )
  
  receiver.view { "Received: $it" }
}

