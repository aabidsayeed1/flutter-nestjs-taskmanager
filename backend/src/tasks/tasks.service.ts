import { BadRequestException, Injectable, InternalServerErrorException, NotFoundException } from '@nestjs/common';
import { InjectRepository } from '@nestjs/typeorm';
import { Brackets, In, Repository } from 'typeorm';
import { CreateTaskDto } from './dtos/create-task.dto';
import { UpdateTaskDto } from './dtos/update-task.dto';
import { Task } from './entities/task.entity';

@Injectable()
export class TasksService {
  constructor(
    @InjectRepository(Task)
    private readonly taskRepository: Repository<Task>,
  ) {}

  async createTask(createTaskDto: CreateTaskDto, userId: string): Promise<Task> {
    const newTask = this.taskRepository.create({
      ...createTaskDto,
      userId,
    });
    return await this.taskRepository.save(newTask);
  }

  async findAllTasks(userId: string): Promise<Task[]> {
    return await this.taskRepository.find({ where: { userId } });
  }

  async findOneTask(id: string, userId: string): Promise<Task> {
    const task = await this.taskRepository.findOne({ where: { id, userId } });
    if (!task) {
      throw new NotFoundException(`Task with ID ${id} not found`);
    }
    return task;
  }

  async updateTask(
    id: string,
    updateTaskDto: UpdateTaskDto,
    userId: string,
  ): Promise<Task> {
    const task = await this.findOneTask(id, userId);
    Object.assign(task, updateTaskDto);
    return await this.taskRepository.save(task);
  }

  async removeTask(id: string, userId: string): Promise<void> {
    const task = await this.findOneTask(id, userId);
    await this.taskRepository.remove(task);
  }
  // Batch Create/Update Tasks
  async batchCreateOrUpdateTasks(
    tasks: (CreateTaskDto | UpdateTaskDto)[],
    userId: string,
  ): Promise<Task[]> {
    const savedTasks: Task[] = [];
  
    for (const taskData of tasks) {
      let parsedTaskData: any;
      if (typeof taskData === 'string') {
        try {
          parsedTaskData = JSON.parse(taskData);
        } catch (error) {
          console.error("Failed to parse taskData:", error);
          throw new BadRequestException("Invalid task data format");
        }
      } else {
        parsedTaskData = taskData;
      }
  
      console.log("Processing task data id:", parsedTaskData.id);
  
      let task: Task;
  
      const existingTask = await this.taskRepository.findOne({
        where: { id: parsedTaskData.id, userId },
      });
      console.log("Existing task for ID:", parsedTaskData.id, existingTask);
  
      if (existingTask) {
        // Update existing task
        Object.assign(existingTask, {
          title: parsedTaskData.title,
          description: parsedTaskData.description,
          date: parsedTaskData.date,
          isDone: parsedTaskData.isDone,
          isDeleted: parsedTaskData.isDeleted,
          isFavorite: parsedTaskData.isFavorite,
          isOffline: parsedTaskData.isOffline,
        });
        task = await this.taskRepository.save(existingTask);
      } else {
        // Create new task
        task = this.taskRepository.create({ ...parsedTaskData as CreateTaskDto, userId }) ;
        task = await this.taskRepository.save(task);
      }
  
      console.log("Saved task:", task);
      savedTasks.push(task);
    }
  
    console.log("All saved tasks:", savedTasks);
    return savedTasks;
  }

   async batchDeleteTasks(taskIds: string[], userId: string): Promise<void> {
    console.log(`task IDs : ${taskIds}`);
    try {
      const existingTasks = await this.taskRepository.find({
        where: { id: In(taskIds), userId },
      });
  
      const validTaskIds = existingTasks.map(task => task.id);
  
      const invalidTaskIds = taskIds.filter(id => !validTaskIds.includes(id));
      if (invalidTaskIds.length > 0) {
        console.log(`Invalid or non-existent task IDs ignored: ${invalidTaskIds.join(', ')}`);
      }
  
      if (validTaskIds.length > 0) {
        await this.taskRepository.delete({ id: In(validTaskIds) });
      }
    } catch (error) {
      console.log('Error occurred while deleting tasks:', error);
      throw new InternalServerErrorException(
        'errors in batch delete failed'
      );
    }
  }
async searchTasks(
  query?: string,
  type?:'pending' | 'completed' | 'favorite' | 'removed',
  userId?: string,
):Promise<Task[]>{
console.log('adsfasdfasd',query,type,userId);
  const qb = this.taskRepository.createQueryBuilder('task');
  if(userId){
    qb.andWhere('task.userId = :userId',{userId});
  }
  if(type){
    switch (type) {
      case 'pending':
        qb.andWhere('task.isDone = :isDone', { isDone: false }).andWhere('task.isDeleted = :isDeleted', { isDeleted: false });
        break;
      case 'completed':
        qb.andWhere('task.isDone = :isDone', { isDone: true }).andWhere('task.isDeleted = :isDeleted', { isDeleted: false });
        break;
      case 'favorite':
        qb.andWhere('task.isFavorite = :isFavorite', { isFavorite: true }).andWhere('task.isDeleted = :isDeleted', { isDeleted: false });
        break;
      case 'removed':
        qb.andWhere('task.isDeleted = :isDeleted', { isDeleted: true });
        break;
      default:
        qb.andWhere('task.isDeleted = :isDeleted', { isDeleted: false });
    }
  }else{
    qb.andWhere('task.isDeleted = :isDeleted', { isDeleted: true });
  }
  if (query) {
    qb.andWhere(
      new Brackets((qb) => {
        qb.where('LOWER(task.title) LIKE LOWER(:query)', { query: `%${query}%` })
          .orWhere('LOWER(task.description) LIKE LOWER(:query)', { query: `%${query}%` });
      })
    );
  }
  console.log('Generated SQL Query:', qb.getSql());
  console.log('Query Parameters:', qb.getParameters());
  return qb.getMany();

}
}