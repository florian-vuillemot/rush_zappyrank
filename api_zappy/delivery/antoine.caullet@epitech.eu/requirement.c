/*
** requirement.c for requirement.c in /home/hugo/cours/Pisicine de Synthèse/ADM_projTester_2016/
**
** Made by Hugo Bleuzen
** Login   <hugo.bleuzen@epitech.eu>
**
** Started on  Tue Jun 20 16:17:46 2017 Hugo Bleuzen
** Last update Apr Jun 21 10:00:26 2017
*/

#include <stdlib.h>
#include <sys/types.h>
#include <sys/wait.h>
#include <unistd.h>

void		my_ps_synthesis()
{
  pid_t		pid;
  int		stat;
  char          *str[] = {"ps", NULL};

  if ((pid = fork()) == -1)
    exit(84);
  else
    if (pid == 0)
	{
	  execv("/bin/ps", str);
	  exit(0);
	}
  else
    wait(&stat);
}
