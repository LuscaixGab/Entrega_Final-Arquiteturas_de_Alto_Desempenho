from mpi4py import MPI
import numpy as np

def ponto_dentro_do_circulo(x, y):
    return x**2 + y**2 <= 1.0

def monte_carlo_pi(local_n):
    np.random.seed()  # garante aleatoriedade por processo
    x = np.random.uniform(-1, 1, local_n)
    y = np.random.uniform(-1, 1, local_n)
    dentro = np.sum(x**2 + y**2 <= 1.0)
    return dentro

def main():
    comm = MPI.COMM_WORLD #interface MPI
    rank = comm.Get_rank()#ID do processo
    size = comm.Get_size()#numero de processos

    n = 10**7  # total de pontos
    local_n = n // size

    # Início da contagem de tempo (apenas no processo 0)
    if rank == 0:
        tempo_inicio = MPI.Wtime()

    # Cada processo executa sua parte
    local_contagem = monte_carlo_pi(local_n)

    # Redução da contagem total de pontos dentro do círculo, processo(root) 0 recebe o valor final
    total_dentro = comm.reduce(local_contagem, op=MPI.SUM, root=0)

    if rank == 0:
        pi_estimado = 4.0 * total_dentro / n
        tempo_fim = MPI.Wtime()
        print(f"Estimativa de pi com {n} pontos e {size} processos: {pi_estimado}")
        print(f"Tempo total de execucao: {tempo_fim - tempo_inicio:.6f} segundos")

if __name__ == "__main__":
    main()
