import time
import numpy as np
import multiprocessing
import matplotlib.pyplot as plt

#gera pontos x,y com valores aleatórios entre -1 e 1
#verifica se o ponto gerado está dentro de um circulo de raio 1
def ponto_dentro_do_circulo(_):
    x, y = np.random.uniform(-1, 1), np.random.uniform(-1, 1) #valores aleatórios entre 1 e -1
    return x**2 + y**2 <= 1.0 #verifica se o valor está dentro do circulo

def monte_carlo_pi_paralelo(n_pontos, n_processos):
    #a biblioteca multiprocessing separa automaticamente a função ponto_dentro_do_circulo
    #em n_processos paralelos
    with multiprocessing.Pool(processes=n_processos) as pool:
        resultados = pool.map(ponto_dentro_do_circulo, range(n_pontos))
    total_dentro = sum(resultados)
    #pi é estimado pela razao entre o numero dentro do circulo pelo total de pontos
    pi_estimado = 4.0 * total_dentro / n_pontos 
    return pi_estimado

#mede o tempo de execucao para calcular speedup
def medir_tempo_e_pi(n_pontos, n_processos):
    inicio = time.time()
    pi = monte_carlo_pi_paralelo(n_pontos, n_processos)
    fim = time.time()
    return fim - inicio, pi

#gera os valores de base 2, para a qntd de núcleos por iteração de acordo com sua cpu
def gerar_potencias_de_2(max_cores):
    potencias = []
    n = 0
    while (valor := 2**n) <= max_cores:
        potencias.append(valor)
        n += 1
    return potencias

def main():
    n_pontos = 10_000_000
    max_cores = multiprocessing.cpu_count() #nucleos da sua cpu ou trocar por valor desejado
    cores_para_testar = gerar_potencias_de_2(max_cores) #conjunto[1,2,4,8,...,max]

    print(f"Número de núcleos disponíveis: {max_cores}")
    print(f"Testando para: {cores_para_testar}\n")

    tempos = []
    estimativas_pi = []

    for n in cores_para_testar:
        print(f"➡ Executando com {n} processo(s)...")
        tempo, pi = medir_tempo_e_pi(n_pontos, n)
        tempos.append(tempo)
        estimativas_pi.append(pi)
        print(f"π ≈ {pi:.8f} | Tempo: {tempo:.4f} segundos\n")

    # Speedup real e ideal
    tempo_base = tempos[0] #cores = 1
    speedups = [tempo_base / t for t in tempos] 
    speedup_ideal = cores_para_testar

    # Plot
    plt.figure(figsize=(8, 5))
    plt.plot(cores_para_testar, speedups, marker='o', label='Speedup real')
    plt.plot(cores_para_testar, speedup_ideal, 'k--', label='Speedup ideal (linear)')
    plt.title('Speedup vs Número de Núcleos')
    plt.xlabel('Número de núcleos')
    plt.ylabel('Speedup')
    plt.xticks(cores_para_testar)
    plt.legend()
    plt.grid(True)
    plt.tight_layout()
    plt.show()

if __name__ == "__main__":
    main()
